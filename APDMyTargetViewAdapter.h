//
//  APDMyTargetViewAdapter.h
//  APDMyTargetAdapter
//
//  Created by Lozhkin Ilya on 7/4/18.
//  Copyright © 2018 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetAdapter.h"

typedef void (^APDMyTargetViewBlock)(MTRGAdView *, NSError *);
typedef void (^APDMyTargetNativeBlock)(MTRGNativeAd *, NSError *);

typedef void (^APDMyTargetViewLoadBlock)(NSDictionary * loadingParameters,
                                         id <APDAdapterDataSource> dataSource,
                                         CGSize adSize,
                                         APDMyTargetViewBlock);
typedef void (^APDMyTargetNativeLoadBlock)(NSDictionary * loadingParameters,
                                           id <APDAdapterDataSource> dataSource,
                                           APDMyTargetNativeBlock);

@interface APDMyTargetAdViewAdapter : APDMyTargetAdapter

@property (nonatomic, copy) APDMyTargetViewBlock didLoadView;
@property (nonatomic, copy) APDMyTargetNativeBlock didLoadNativeAd;

- (APDMyTargetViewLoadBlock)loadAdView;
- (APDMyTargetNativeLoadBlock)loadNativeAdView;

- (void)presentView:(UIView *)view
         completion:(void(^)(MTRGAdView *))completion;

@end
