//
//  APDMyTargetAdapter.m
//  APDMyTargetAdapter
//
//  Created by Lozhkin Ilya on 7/4/18.
//  Copyright © 2018 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetAdapter.h"
#import "APDMyTargetAdNetwork.h"

@implementation APDMyTargetAdapter

- (NSDictionary *(^)(NSDictionary *, NSError **))biddingParameters {
    return ^NSDictionary *(NSDictionary *loadingParameters, NSError * *error) {
        id slotID = loadingParameters[@"mailru_slot_id"];
        [NSObject ask_verify:slotID typeError:error];
        NSUInteger slotValue = self.transformedSlot(slotID);
        return @{
                 @"slot_id" : @(slotValue)
                 };
    };
}

- (APDMyTargetValidationBlock)loadMyTarget {
    return ^(NSDictionary *customInfo,
             id <APDAdapterDataSource> dataSource,
             APDMyTargetLoadingBlock loadingBlock) {
        // Get parameters that are needed for request
        NSString * bidID = customInfo[@"bid_id"];
        id slotID = customInfo[@"mailru_slot_id"] ?: customInfo[@"slot_id"];
        
        // Configure MyTarget SDK paramters
        __weak typeof(dataSource) weakDataSource = dataSource;
        void(^populateParamsBlock)(MTRGCustomParams *) = ^(MTRGCustomParams * params) {
            [params setCustomParam:bidID
                            forKey:@"bid_id"];
            
            APDAdapterMetadata * metadata = [[APDAdapterMetadata alloc] initWithDataSource:weakDataSource];
            if (!metadata) {
                return;
            }
            
            [MTRGPrivacy setUserConsent:metadata.hasUserConsent];
            [MTRGPrivacy setUserAgeRestricted:metadata.isChildApp];
            
            if (metadata.isNeededRestrictDataStorage || metadata.isChildApp) {
                return;
            }
            
            params.age = @([metadata.userInfo age]);
            params.email = [metadata.userInfo email];
            params.gender = (MTRGGender)[metadata.userInfo gender];
        };
        
        loadingBlock(self.transformedSlot(slotID),
                     populateParamsBlock);
    };
}

- (NSError *(^)(APDError, NSString *))error {
    return ^NSError *(APDError code, NSString *description) {
        return [NSError apd_errorWithCode:code
                              description:description
                           adNetworkClass:APDMyTargetAdNetwork.class];
    };
}

#pragma mark - Private

- (NSUInteger(^)(id))transformedSlot {
    return ^NSUInteger (id slotID) {
        NSUInteger slotValue = NSNotFound;
        if (NSString.ask_isValid(slotID)) {
            static NSNumberFormatter *_formatter;
            if (!_formatter) {
                _formatter = [[NSNumberFormatter alloc] init];
            }
            slotValue = [_formatter numberFromString:slotID].unsignedIntegerValue;
        } else if (NSNumber.ask_isValid(slotID)) {
            slotValue = [slotID unsignedIntegerValue];
        }
        return slotValue;
    };
}

@end
