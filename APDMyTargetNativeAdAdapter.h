//
//  APDmyTargetNativeAd.h
//
//  Copyright © 2016 Appodeal, Inc. All rights reserved.
//

#import <Appodeal/AppodealPrivateHeaders.h>

#import <MyTargetSDK/MyTargetSDK.h>

@interface APDMyTargetNativeAdAdapter : NSObject <APDNativeAdAdapter>

@property (nonatomic, strong) MTRGNativeAd *nativeAd;

+ (APDMyTargetNativeAdAdapter *)wrappedMyTargetAd:(MTRGNativeAd *)myTargetAd;

@end
