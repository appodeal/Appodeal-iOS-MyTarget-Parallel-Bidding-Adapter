//
//  APDMyTargetNativeServiceAdAdapter.m
//
//  Copyright © 2016 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetNativeAdServiceAdapter.h"
#import "APDMyTargetAdNetwork.h"
#import "APDFactory+MyTarget.h"

@interface APDMyTargetNativeAdServiceAdapter ()

@end

@implementation APDMyTargetNativeAdServiceAdapter

- (Class)relativeNativeAdClass {
    return [APDMyTargetNativeAdAdapter class];
}

- (NSString *)networkName {
    return [APDMyTargetAdNetwork name];
}

#pragma mark - Public

- (void)loadWithCustomInfo:(NSDictionary *)customInfo {
    [self subscribeOnCallback];
    __weak typeof(self) weakSelf = self;
    self.loadNativeAdView(customInfo,
                          self.dataSource,
                          ^(MTRGNativeAd * nativeAd, NSError * error) {
                              if (error) {
                                  [weakSelf.delegate adapter:weakSelf
                                    didFailToLoadAdWithError:error];
                              }
                          });
}

#pragma mark - Private

- (void)subscribeOnCallback {
    __weak __typeof__(self) _weak = self;
    self.didLoadNativeAd = ^(MTRGNativeAd *nativeAd, NSError * error) {
        APDMyTargetNativeAdAdapter *wrappedAd = [[APDFactory sharedFactory] wrappedMyTargetAd:nativeAd];
        [_weak.delegate service:_weak didLoadNativeAds:@[wrappedAd]];
    };
    
    self.failLoad = ^(NSError *error){
        [_weak.delegate adapter:_weak didFailToLoadAdWithError:error];
    };
}

@end
