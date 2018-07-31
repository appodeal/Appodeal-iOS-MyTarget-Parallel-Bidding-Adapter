//
//  APDMyTargetAdapter.h
//  APDMyTargetAdapter
//
//  Created by Lozhkin Ilya on 7/4/18.
//  Copyright © 2018 Appodeal, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MyTargetSDK/MyTargetSDK.h>
#import <ASKExtension/ASKExtension.h>
#import <Appodeal/AppodealPrivateHeaders.h>

@class APDMyTargetAdapter;

typedef void (^APDMyTargetTargetingBlock)(MTRGCustomParams *customParams);
typedef void (^APDMyTargetLoadingBlock)(NSUInteger slotID,
                                        APDMyTargetTargetingBlock);
typedef void (^APDMyTargetValidationBlock)(NSDictionary * mediationData,
                                           id<APDAdapterDataSource> dataSource,
                                           APDMyTargetLoadingBlock);
typedef void (^APDMyTargetBlock)(void);
typedef void (^APDMyTargetFailBlock)(NSError *);

@interface APDMyTargetAdapter : NSObject

@property (nonatomic, copy) APDMyTargetBlock didLoad;
@property (nonatomic, copy) APDMyTargetBlock didClick;
@property (nonatomic, copy) APDMyTargetFailBlock failLoad;

- (NSDictionary *(^)(NSDictionary *, NSError **))biddingParameters;

- (APDMyTargetValidationBlock)loadMyTarget;

- (NSError *(^)(APDError, NSString *))error;

@end

