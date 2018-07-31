//
//  APDMyTargetInterstitialAdAdapter.m
//
//  Copyright © 2015 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetInterstitialAdAdapter.h"
#import "APDMyTargetAdNetwork.h"

@interface APDMyTargetInterstitialAdAdapter ()

@property (nonatomic, readwrite, weak) UIView *adView;
@property (nonatomic, readwrite, copy) NSString *adContent;

@end

@implementation APDMyTargetInterstitialAdAdapter

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

- (void)loadAdWithCustomInfo:(NSDictionary *)customInfo {
    [self subscribeOnCallback];
    __weak typeof(self) weakSelf = self;
    self.loadModalAd(customInfo, self.dataSource, ^(MTRGInterstitialAd * interstitial, NSError * error) {
        if (error) {
            [weakSelf.delegate adapter:weakSelf didFailToLoadAdWithError:error];
        }
    });
}

- (void)presentAdFromViewController:(UIViewController *)viewController {
    [self presentModal:viewController completion:^(MTRGInterstitialAd *interstitial) {
        [self tryToGetAdContent:interstitial controller:viewController];
    }];
}

#pragma mark - Private

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
        [_weak.delegate interstitialAdapterDidReceiveTapAction:_weak];
    };
}

- (void)tryToGetAdContent:(MTRGInterstitialAd *)interstitial
               controller:(UIViewController *)controller {
    
    NSDictionary * jsonDict = [interstitial ask_valueForKeyPath:@"adData.jsonDict"];
    NSMutableDictionary * adWatchData = [NSMutableDictionary new];

    id banners = jsonDict[@"fullscreen"][@"banners"];
    if ([banners isKindOfClass:[NSArray class]]) {
        adWatchData[@"imageUrl"] = banners[0][@"imageLink"];
    } else if ([banners isKindOfClass:[NSDictionary class]]) {
        adWatchData[@"imageUrl"] = banners[@"imageLink"];
    }
    
    NSError * serError;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:adWatchData
                                                        options:0
                                                          error:&serError];
    self.adView = controller.presentedViewController.view;
    self.adContent = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
