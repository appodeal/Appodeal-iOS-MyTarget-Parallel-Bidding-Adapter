//
//  APDMyTargetViewAdapter.m
//  APDMyTargetAdapter
//
//  Created by Lozhkin Ilya on 7/4/18.
//  Copyright © 2018 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetViewAdapter.h"
#import "APDMyTargetAdNetwork.h"
#import "APDFactory+MyTarget.h"


@interface APDMyTargetAdViewAdapter ()<MTRGAdViewDelegate, MTRGNativeAdDelegate>

@property (nonatomic, strong) MTRGAdView *banner;
@property (nonatomic, strong) MTRGNativeAd *nativeAd;

@end

@implementation APDMyTargetAdViewAdapter

- (void)dealloc {
    // Avoid backround calls
    if (NSThread.isMainThread) {
        [self.banner stop];
    }
}

#pragma mark - Public

- (APDMyTargetViewLoadBlock)loadAdView {
    return ^(NSDictionary *customInfo,
             id <APDAdapterDataSource> dataSource,
             CGSize size,
             APDMyTargetViewBlock completion) {
        
        self.loadMyTarget(customInfo, dataSource, ^(NSUInteger slotID, APDMyTargetTargetingBlock targeting){
            if (slotID == NSNotFound) {
                NSError * error = [NSError apd_errorWithCode:APDIncorrectAdUnitError description:@"Trying to load invalid banner ad unit"];
                ASK_RUN_BLOCK(completion, nil, error);
                return;
            }
            
            CGSize currentSize = size;
            if (CGSizeEqualToSize(CGSizeZero, currentSize)) {
                currentSize = ASK_TABLETE ? kAPDAdSize728x90 : kAPDAdSize320x50;
            }

            self.banner = [APDFactory.sharedFactory myTargetAdViewWithSlotId:slotID];
            self.banner.delegate = self;
            self.banner.frame = (CGRect){.size = currentSize};
            
            targeting(self.banner.customParams);
            ASK_RUN_BLOCK(completion, self.banner, nil);
            
            [self.banner load];
        });
    };
}

- (APDMyTargetNativeLoadBlock)loadNativeAdView {
    return ^(NSDictionary *customInfo,
             id<APDAdapterDataSource> dataSource,
             APDMyTargetNativeBlock completion) {
        
        self.loadMyTarget(customInfo, dataSource, ^(NSUInteger slotID, APDMyTargetTargetingBlock targeting) {
            if (slotID == NSNotFound) {
                NSError * error = [NSError apd_errorWithCode:APDIncorrectAdUnitError
                                                 description:@"Trying to load invalid ad unit"];
                ASK_RUN_BLOCK(completion, nil, error);
                return;
            }
            
            self.nativeAd = [APDFactory.sharedFactory myTargetNativeWithSlotId:slotID];
            self.nativeAd.autoLoadImages = NO;
            self.nativeAd.delegate = self;
            
            targeting(self.nativeAd.customParams);
            ASK_RUN_BLOCK(completion, self.nativeAd, nil);

            [self.nativeAd load];
        });
    };
}

- (void)presentView:(UIView *)view
         completion:(void (^)(MTRGAdView *))completion {
    
    ASK_RUN_BLOCK(completion, self.banner);
    [self.banner start];
}

#pragma mark - MTRGAdViewDelegate

- (void)onLoadWithAdView:(MTRGAdView *)adView {
    [adView apd_alignFirstSubviewToCenter];
    ASK_RUN_BLOCK(self.didLoadView, adView, nil);
}

- (void)onNoAdWithReason:(NSString *)reason adView:(MTRGAdView *)adView {
    ASK_RUN_BLOCK(self.failLoad, self.error(APDNoFillError, reason));
}

- (void)onAdClickWithAdView:(MTRGAdView *)adView {
    ASK_RUN_BLOCK(self.didClick);
}

#pragma mark - MTRGNativeAdDelegate

- (void)onLoadWithNativePromoBanner:(MTRGNativePromoBanner *)promoBanner nativeAd:(MTRGNativeAd *)nativeAd{
    ASK_RUN_BLOCK(self.didLoadNativeAd, nativeAd, nil);
}

- (void)onNoAdWithReason:(NSString *)reason nativeAd:(MTRGNativeAd *)nativeAd{
    ASK_RUN_BLOCK(self.failLoad, self.error(APDNoFillError, reason));
}

@end

