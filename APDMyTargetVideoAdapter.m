//
//  APDMyTargetVideoAdapter.m
//
//  Copyright © 2016 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetVideoAdapter.h"
#import "APDMyTargetAdNetwork.h"

@interface APDMyTargetVideoAdapter ()

@property (nonatomic, readwrite, weak) UIView *adView;
@property (nonatomic, readwrite, copy) NSString *adContent;

@property (nonatomic, assign) BOOL rewarded;

@end

@implementation APDMyTargetVideoAdapter

- (BOOL)allowMultipleLoading {
    return YES;
}

- (NSString *)networkName {
    return APDMyTargetAdNetwork.name;
}

- (NSString *)customContentType{
    return kAPDJSONContentType;
}

#pragma mark - Public

- (void)loadSkippableVideoAdWithCustomInfo:(NSDictionary *)customInfo {
    [self loadVideoAdWithCustomInfo:customInfo];
}

- (void)loadRewardedVideoAdWithCustomInfo:(NSDictionary *)customInfo {
    self.rewarded = YES;
    [self loadVideoAdWithCustomInfo:customInfo];
}

- (void)presentAdFromViewController:(UIViewController *)viewController {
    [self presentModal:viewController completion:^(MTRGInterstitialAd *interstitial) {
        [self tryToGetAdContent:interstitial controller:viewController];
    }];
}

#pragma mark - Private

- (void)loadVideoAdWithCustomInfo:(NSDictionary *)customInfo {
    __weak typeof(self) weakSelf = self;
    [self subscribeOnCallback];
    self.loadModalAd(customInfo, self.dataSource, ^(MTRGInterstitialAd * interstitial, NSError * error) {
        if (error) {
            [weakSelf.delegate adapter:weakSelf didFailToLoadAdWithError:error];
        }
    });
}

- (void)subscribeOnCallback {
    __weak __typeof__(self) _weak = self;
    self.didLoad = ^{
        [_weak.delegate adapterDidLoadAd:_weak];
    };
    
    self.failLoad = ^(NSError *error){
        [_weak.delegate adapter:_weak didFailToLoadAdWithError:error];
    };
    
    self.didPresent = ^{
        [_weak.delegate modalAdapterWillPresentAd:_weak];
    };
    
    self.didDismiss = ^{
        [_weak.delegate modalAdapterDidDismissAd:_weak];
    };
    
    self.didClick = ^{
        [_weak.delegate videoAdapterDidReciveTapAction:_weak];
    };
    
    self.didFinish = ^{
        [_weak.delegate videoPlaybackEndedInAdapter:_weak fullyWatched:YES];
    };
}

- (void)tryToGetAdContent:(MTRGInterstitialAd *)interstitial
               controller:(UIViewController *)controller {
    if (self.rewarded) {
        [UIView apd_validateObject:[interstitial ask_valueForKeyPath:@"fsAd.bannerView"] success:^(UIView * object) {
            self.adView = object;
        }];
        
        [NSString apd_validateObject:[interstitial ask_valueForKeyPath:@"fsAd.rawData"] success:^(NSString * object) {
            self.adContent = object;
        }];
    } else {
        self.adView = [controller presentedViewController].view;
    }
}

@end
