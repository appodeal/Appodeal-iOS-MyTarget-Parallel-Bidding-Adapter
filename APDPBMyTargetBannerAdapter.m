//
//  APDPBMyTargetBannerAdapter.m
//  APDMyTargetAdapter
//
//  Created by Lozhkin Ilya on 7/4/18.
//  Copyright © 2018 Appodeal, Inc. All rights reserved.
//

#import "APDPBMyTargetBannerAdapter.h"
#import "APDMyTargetAdNetwork.h"

@interface APDPBMyTargetBannerAdapter ()

@end

@implementation APDPBMyTargetBannerAdapter

- (Class)relativeAdNetworkClass {
    return APDMyTargetAdNetwork.class;
}

- (NSString *)adContent {
    return nil;
}

#pragma mark - Public

- (NSDictionary *)externalBiddingInformationForLoadingParamters:(NSDictionary *)loadingParameters
                                                          error:(NSError **)error {
    return self.biddingParameters(loadingParameters, error);
}

- (void)prepareContent:(NSDictionary *)contentInfo {
    [self subscribeOnCallback];
    __weak typeof(self) weakSelf = self;
    self.loadAdView(contentInfo,
                    APDMyTargetAdNetwork.sharedNetwork.dataSource,
                    CGSizeZero,
                    ^(MTRGAdView * banner, NSError * error){
                        banner.viewController = [weakSelf.delegate rootViewControllerForAdapter:weakSelf];
                        if (error) {
                            [weakSelf.delegate adapter:weakSelf failedToPrepareContentWithError:error];
                        }
                    });
}

- (void)presentInContainer:(UIView *)container {
    [self presentView:container completion:^(MTRGAdView *adView) {
        adView.frame = (CGRect){.size = container.frame.size};
//        [self tryToGetAdContent:adView];
    }];
}

#pragma mark - Private

- (void)subscribeOnCallback {
    __weak __typeof__(self) _weak = self;
    self.didLoadView = ^(UIView *view, NSError *error) {
        // Ignore error here
        [_weak.delegate adapterPreparedContent:_weak];
    };
    
    self.failLoad = ^(NSError *error){
        [_weak.delegate adapter:_weak failedToPrepareContentWithError:error];
    };
    
    self.didClick = ^{
        [_weak.delegate adapterRegisterUserInteraction:_weak];
    };
}

@end
