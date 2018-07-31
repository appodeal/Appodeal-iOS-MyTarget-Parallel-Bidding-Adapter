//
//  APDPBMyTargetModalAdapter.m
//  APDMyTargetAdapter
//
//  Created by Lozhkin Ilya on 7/4/18.
//  Copyright © 2018 Appodeal, Inc. All rights reserved.
//

#import "APDPBMyTargetModalAdapter.h"
#import "APDMyTargetAdNetwork.h"

@interface APDPBMyTargetModalAdapter ()

@end

@implementation APDPBMyTargetModalAdapter

- (Class)relativeAdNetworkClass {
    return APDMyTargetAdNetwork.class;
}

- (NSString *)adContent {
    return nil;
}

- (UIView *)adView {
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
    self.loadModalAd(contentInfo,
                     APDMyTargetAdNetwork.sharedNetwork.dataSource,
                     ^(MTRGInterstitialAd * interstitial, NSError * error) {
                         if (error) {
                             [weakSelf.delegate adapter:weakSelf failedToPrepareContentWithError:error];
                         }
                     });
}

- (void)present {
    UIViewController *viewController = [self.delegate rootViewControllerForAdapter:self];
    [self presentModal:viewController completion:^(MTRGInterstitialAd *interstitial) {
        
    }];
}

#pragma mark - Private

- (void)subscribeOnCallback {
    __weak __typeof__(self) _weak = self;
    self.didLoad = ^{
        [_weak.delegate adapterPreparedContent:_weak];
    };
    
    self.failLoad = ^(NSError *error){
        [_weak.delegate adapter:_weak failedToPrepareContentWithError:error];
    };
    
    self.didPresent = ^{
        [_weak.delegate adapterWillPresent:_weak];
    };
    
    self.didDismiss = ^{
        [_weak.delegate adapterDidDissmiss:_weak];
    };
    
    self.didClick = ^{
        [_weak.delegate adapterRegisterUserInteraction:_weak];
    };
    
    self.didFinish = ^{
        [_weak.delegate adapterFinishRewardAction:_weak];
    };
}

@end
