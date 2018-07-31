//
//  APDMyTargetModalAdapter.m
//  APDMyTargetAdapter
//
//  Created by Lozhkin Ilya on 7/4/18.
//  Copyright © 2018 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetModalAdapter.h"
#import "APDFactory+MyTarget.h"
#import <Appodeal/AppodealPrivateHeaders.h>

@interface APDMyTargetModalAdapter ()<MTRGInterstitialAdDelegate>

@property (strong, nonatomic) MTRGInterstitialAd *interstitial;

@end

@implementation APDMyTargetModalAdapter

- (APDMyTargetModalAdLoadingBlock)loadModalAd {
    return ^(NSDictionary *customInfo,
             id <APDAdapterDataSource> dataSource,
             APDMyTargetModalAdLoadingCompletionBlock completion){
        
        self.loadMyTarget(customInfo, dataSource, ^(NSUInteger slotID, void(^populateBlock)(MTRGCustomParams *)) {
            if (slotID == NSNotFound) {
                NSError * error = [NSError apd_errorWithCode:APDIncorrectAdUnitError
                                                 description:@"Trying to load invalid ad unit!"];
                ASK_RUN_BLOCK(completion, nil, error);
                return;
            }
            
            self.interstitial = [APDFactory.sharedFactory myTargetInterstitialAdWithSlotId:slotID];
            self.interstitial.delegate = self;
            
            populateBlock(self.interstitial.customParams);
            ASK_RUN_BLOCK(completion, self.interstitial, nil);
            
            [self.interstitial load];
        });
    };
}

- (void)presentModal:(UIViewController *)viewController
          completion:(void (^)(MTRGInterstitialAd *))completion {
    [self.interstitial showWithController:viewController];
    ASK_RUN_BLOCK(completion, self.interstitial);
}

#pragma mark - MTRGInterstitialAdDelegate

- (void)onDisplayWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd {
    ASK_RUN_BLOCK(self.didPresent);
}

- (void)onLoadWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd {
    ASK_RUN_BLOCK(self.didLoad);
}

- (void)onNoAdWithReason:(NSString *)reason interstitialAd:(MTRGInterstitialAd *)interstitialAd {
    ASK_RUN_BLOCK(self.failLoad, self.error(APDNoFillError, reason));
}

- (void)onClickWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd {
    ASK_RUN_BLOCK(self.didClick);
}

- (void)onCloseWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd {
    ASK_RUN_BLOCK(self.didDismiss);
}

- (void)onVideoCompleteWithInterstitialAd:(MTRGInterstitialAd *)interstitialAd {
    ASK_RUN_BLOCK(self.didFinish);
}

@end
