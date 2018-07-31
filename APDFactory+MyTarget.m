//
//  APDFactory+MyTarget.m
//
//  Copyright © 2015 Appodeal, Inc. All rights reserved.
//

#import "APDFactory+MyTarget.h"

@implementation APDFactory (MyTarget)

- (MTRGAdView *)myTargetAdViewWithSlotId:(NSUInteger)slotId {
    return [[MTRGAdView alloc] initWithSlotId:slotId withRefreshAd:NO];
}

- (MTRGInterstitialAd *)myTargetInterstitialAdWithSlotId:(NSUInteger)slotId {
    return [[MTRGInterstitialAd alloc] initWithSlotId:slotId];
}

- (MTRGNativeAd*)myTargetNativeWithSlotId:(NSUInteger)slotId {
    return [[MTRGNativeAd alloc] initWithSlotId:slotId];
}

- (APDMyTargetNativeAdAdapter *)wrappedMyTargetAd:(MTRGNativeAd *)myTargetAd{
    return [APDMyTargetNativeAdAdapter wrappedMyTargetAd:myTargetAd];
}

@end
