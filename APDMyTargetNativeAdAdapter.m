//
//  APDmyTargetNativeAd.m
//
//  Copyright © 2016 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetNativeAdAdapter.h"

#import "APDMyTargetNativeAdRenderer.h"

@implementation APDMyTargetNativeAdAdapter

+ (APDMyTargetNativeAdAdapter *)wrappedMyTargetAd:(MTRGNativeAd *)myTargetAd {
    APDMyTargetNativeAdAdapter* wrappedAd = [[APDMyTargetNativeAdAdapter alloc] init];
    wrappedAd.nativeAd = myTargetAd;
    
    return wrappedAd;
}

- (NSString *)title {
    return self.nativeAd.banner.title;
}

- (NSString *)descriptionText {
    return self.nativeAd.banner.descriptionText;
}

- (NSString *)callToActionText {
    return self.nativeAd.banner.ctaText;
}

- (NSString *)contentRating {
    return self.nativeAd.banner.ageRestrictions;
}

- (NSNumber *)starRating {
    return self.nativeAd.banner.rating;
}

- (NSString *)mainImageUrlString {
    return self.nativeAd.banner.image.url;
}

- (NSString *)iconImageUrlString {
    return self.nativeAd.banner.icon.url;
}

- (CGSize)mainImageSize {
    return self.nativeAd.banner.image.size;
}

- (CGSize)iconImageSize {
    return self.nativeAd.banner.icon.size;
}

- (NSURL *)videoUrl {
    __block NSURL * url = nil;
    [NSString apd_validateObject:[[[self.nativeAd apd_safeValueForKeyPath:@"nativeAdBanner.videoBanner.videoDatas"] apd_safeFirstObject] apd_safeValueForKeyPath:@"url"]  success:^(NSString * object) {
        url = [NSURL URLWithString:object];
    }];
    
    return url;
}

- (Class<APDNativeAdViewRenderer>)customRendererClass{
    return APDMyTargetNativeAdRenderer.class;
}

@end
