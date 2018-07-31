//
//  APDMyTargetBannerAdapter.m
//
//  Copyright © 2015 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetBannerAdapter.h"
#import "APDMyTargetAdNetwork.h"
#import "APDFactory+MyTarget.h"

@interface APDMyTargetBannerAdapter ()

@property (nonatomic, readwrite) UIView *adView;
@property (nonatomic, readwrite) NSString *adContent;

@end

@implementation APDMyTargetBannerAdapter

- (NSString *)customContentType {
    return kAPDJSONContentType;
}

- (NSString *)networkName {
    return [APDMyTargetAdNetwork name];
}

- (void)loadAdWithSize:(CGSize)size customInfo:(NSDictionary *)customInfo {
    [self subscribeOnCallback];
    __weak typeof(self) weakSelf = self;
    self.loadAdView(customInfo, self.dataSource, size, ^(MTRGAdView *banner, NSError * error) {
        weakSelf.adView = banner;
        banner.viewController = [weakSelf.dataSource viewControllerForPresentingModalViewForBannerAdapter:weakSelf];
        if (error) {
            [weakSelf.delegate adapter:weakSelf didFailToLoadAdWithError:error];
        }
    });
}

#pragma mark - Private

- (void)subscribeOnCallback {
    __weak __typeof__(self) _weak = self;
    self.didLoadView = ^(UIView *view, NSError * error) {
        [_weak.delegate bannerAdapter:_weak didLoadWithView:view];
    };
    
    self.failLoad = ^(NSError *error) {
        [_weak.delegate adapter:_weak didFailToLoadAdWithError:error];
    };
    
    self.didClick = ^{
        [_weak.delegate bannerdapterDidReceiveTapAction:_weak];
    };
}

- (void)showAdView {
    [self presentView:nil completion:^(MTRGAdView *adView) {
        [self tryToGetAdContent:adView];
    }];
}

#pragma mark - Private

- (void)tryToGetAdContent:(MTRGAdView *)banner {
    NSDictionary * jsonDict = [banner ask_valueForKeyPath:@"engine.jsonDict"];
    
    NSMutableDictionary * adWatchData = [NSMutableDictionary new];
    
    id banners = jsonDict[@"standard_320x50"][@"banners"];
    if ([banners isKindOfClass:[NSArray class]]) {
        adWatchData[@"imageUrl"] = banners[0][@"imageLink"];
    } else if ([banners isKindOfClass:[NSDictionary class]]) {
        adWatchData[@"imageUrl"] = banners[@"imageLink"];
    }
    
    NSError * serError;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:adWatchData options:0 error:&serError];
    
    self.adContent = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
