//
//  APDFactory+MyTarget.h
//
//  Copyright © 2015 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetNativeAdAdapter.h"
#import <MyTargetSDK/MyTargetSDK.h>

@interface APDFactory (MyTarget)

- (MTRGAdView *)myTargetAdViewWithSlotId:(NSUInteger)slotId;

- (MTRGInterstitialAd *)myTargetInterstitialAdWithSlotId:(NSUInteger)slotId;

- (MTRGNativeAd *)myTargetNativeWithSlotId:(NSUInteger)slotId;

- (APDMyTargetNativeAdAdapter *)wrappedMyTargetAd:(MTRGNativeAd *)myTargetAd;

@end
