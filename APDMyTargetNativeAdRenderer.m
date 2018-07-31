//
//  APDMyTargetNativeAdRenderer.m
//
//  Copyright © 2017 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetNativeAdRenderer.h"

#import "APDMyTargetNativeAdAdapter.h"

@interface APDMyTargetNativeAdRenderer () <MTRGNativeAdDelegate, APDImpressionDetectorDelegate>

@property (assign, nonatomic) Class targetViewClass;

@property (nonatomic, strong, readwrite) UIView<APDNativeAdView> * view;

@property (nonatomic, weak) UIViewController * rootViewController;
@property (nonatomic, weak) APDMyTargetNativeAdAdapter * adapter;

//@property (nonatomic, strong) MTRGContentStreamAdView * contentStreamView;
@property (nonatomic, strong) APDImpressionDetector * impressionDetector;

@end

@implementation APDMyTargetNativeAdRenderer

- (void)dealloc {
    [self.adapter.nativeAd unregisterView];
}

+ (instancetype)rendererForAdViewClass:(Class<APDNativeAdView>)adViewClass {
    APDMyTargetNativeAdRenderer * renderer = [self new];
    renderer.targetViewClass = adViewClass;
    return renderer;
}

- (void)renderNativeAd:(APDNativeAd *)nativeAd
               adapter:(id<APDNativeAdAdapter>)adapter
              settings:(APDNativeAdSettings *)settings
    rootViewController:(UIViewController *)rootViewController {
    
    if (![adapter isKindOfClass:APDMyTargetNativeAdAdapter.class]) {
        return;
    }
    
    self.rootViewController = rootViewController;
    self.adapter = (APDMyTargetNativeAdAdapter *)adapter;
    self.adapter.nativeAd.delegate = self;
    
    UIView <APDNativeAdView> * preparedView;
    
    if ([self.targetViewClass respondsToSelector:@selector(nib)]) {
        UINib * nib = [self.targetViewClass nib];
        preparedView = [[nib instantiateWithOwner:nib options:nil] firstObject];
    } else {
        preparedView = [[self.targetViewClass alloc] init];
    }
    
    preparedView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    // Required
    preparedView.titleLabel.text            = nativeAd.title;
    preparedView.callToActionLabel.text     = nativeAd.callToActionText;

    // Optional
    if (nativeAd.descriptionText &&
        [preparedView respondsToSelector:@selector(descriptionText)]) {
        preparedView.descriptionLabel.text = nativeAd.descriptionText;
    }
    
    if (nativeAd.iconImage
        && [preparedView respondsToSelector:@selector(iconView)]) {
        [preparedView.iconView apd_setImageFromURL:nativeAd.iconImage.url];
    }
    
    if (nativeAd.starRating &&
        [preparedView respondsToSelector:@selector(setRating:)]) {
        [preparedView setRating:nativeAd.starRating];
    }
    
    if (nativeAd.contentRating &&
        [preparedView respondsToSelector:@selector(contentRatingLabel)]) {
        preparedView.contentRatingLabel.text = nativeAd.contentRating;
    }
    
    if ([preparedView respondsToSelector:@selector(mediaContainerView)]) {
        MTRGContentStreamAdView * contentStreamView = self.adView;
        [self.adapter.nativeAd registerView:contentStreamView
                             withController:self.rootViewController];
        [contentStreamView.mediaAdView removeFromSuperview];
        [preparedView.mediaContainerView addSubview:contentStreamView.mediaAdView];
        [contentStreamView.mediaAdView apd_makeEdgesEqualToEdgesOfView:preparedView.mediaContainerView];
    }
    
    [self.adapter.nativeAd registerView:preparedView
                             withController:self.rootViewController];
    
    self.view = preparedView;
    self.adapter.nativeAd.delegate = self;
    
    [self observeImpression];
}

- (MTRGContentStreamAdView *)adView {
    MTRGContentStreamAdView * adView = [MTRGNativeViewsFactory createContentStreamViewWithBanner:self.adapter.nativeAd.banner];
    [adView loadImages];
    return adView;
}

//- (MTRGContentStreamAdView *)contentStreamView {
//    if (!_contentStreamView) {
//        _contentStreamView = [MTRGNativeViewsFactory createContentStreamViewWithBanner:self.adapter.nativeAd.banner];
//        [_contentStreamView loadImages];
//    }
//    return _contentStreamView;
//}

#pragma mark - Private

- (void)observeImpression {
    //TODO: Use factory from core here
    self.impressionDetector = [[APDImpressionDetector alloc] initWithMinImpressionInterval:0.25f
                                                                   minVisibilityPercentage:75];
    self.impressionDetector.delegate = self;
    [self.impressionDetector attachToTargetView:self.view
                           withOverlayDetection:NO
                   viewabilityDetectionInterval:[self.delegate viewabilityIntervalForRenderer:self]];
}

- (void)observeInteraction {}

#pragma mark - APDImpressionDetectorDelegate

- (void)impressionDetector:(APDImpressionDetector *)impressionDetector
didDetectImpressionForView:(UIView *)view {
    
    if (self.view == view) {
        [self.delegate renderer:self
     detectImpressionForAdapter:self.adapter
                         onView:self.view];
    }
}

- (void)impressionDetector:(APDImpressionDetector *)impressionDetector
    didDetectFinishForView:(UIView *)view {
    if (view == self.view) {
        [self.delegate renderer:self
         detectFinishForAdapter:self.adapter
                         onView:self.view];
    }
}

#pragma mark - MTRGNativeAdDelegate

- (void)onLoadWithNativePromoBanner:(MTRGNativePromoBanner *)promoBanner nativeAd:(MTRGNativeAd *)nativeAd {}

- (void)onNoAdWithReason:(NSString *)reason nativeAd:(MTRGNativeAd *)nativeAd {}

- (void)onAdClickWithNativeAd:(MTRGNativeAd *)nativeAd{
    [self.delegate renderer:self
detectInteractionForAdapter:self.adapter
                     onView:self.view];
}

@end
