//
//  APDMyTargetAdNetwork.m
//
//  Copyright © 2015 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetAdNetwork.h"

#import "APDMyTargetVideoAdapter.h"
#import "APDMyTargetBannerAdapter.h"
#import "APDMyTargetInterstitialAdAdapter.h"
#import "APDMyTargetNativeAdServiceAdapter.h"

#import "APDPBMyTargetModalAdapter.h"
#import "APDPBMyTargetBannerAdapter.h"

@implementation APDMyTargetAdNetwork

+ (void)load {
    [super registerAdNetworkClass:self];
}

+ (NSString *)name {
    return @"mailru";
}

+ (NSString *)sdkVersion {
    return @"4.7.9";
}

+ (NSString *)prettyName {
    return @"Mail.Ru myTarget";
}

+ (Class<APDBannerAdapter>)bannerAdapterClass {
    return [APDMyTargetBannerAdapter class];
}


+ (Class<APDNativeAdAdapter>)nativeAdAdapterClass {
    return [APDMyTargetNativeAdServiceAdapter class];
}


+ (Class<APDInterstitialAdAdapter>)interstitialAdAdapterClass {
    return [APDMyTargetInterstitialAdAdapter class];
}

+ (Class<APDSkippableVideoAdapter>)skippableVideoAdapterClass {
    return [APDMyTargetVideoAdapter class];
}

+ (Class<APDRewardedVideoAdapter>)rewardedVideoAdapterClass {
    return [APDMyTargetVideoAdapter class];
}

#pragma mark - ADXNetwork

+ (Class<ADXFullscreenAdapter>)videoAdapterClassForSdk:(ADXSdk *)sdk {
    return APDPBMyTargetModalAdapter.class;
}

+ (Class<ADXFullscreenAdapter>)interstitialAdAdapterClassForSdk:(ADXSdk *)sdk {
    return APDPBMyTargetModalAdapter.class;
}

+ (Class<ADXBannerAdapter>)bannerAdapterClassForSdk:(ADXSdk *)sdk {
    return APDPBMyTargetBannerAdapter.class;
}

+ (instancetype)sharedNetwork {
    static APDMyTargetAdNetwork * _network;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _network = [APDMyTargetAdNetwork new];
    });
    return _network;
}

@end
