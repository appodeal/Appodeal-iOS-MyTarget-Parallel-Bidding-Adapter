//
//  APDMyTargetModalAdapter.h
//  APDMyTargetAdapter
//
//  Created by Lozhkin Ilya on 7/4/18.
//  Copyright © 2018 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetAdapter.h"

@class APDMyTargetModalAdapter;

typedef void (^APDMyTargetModalBlock)(void);
typedef void (^APDMyTargetModalAdLoadingCompletionBlock)(MTRGInterstitialAd * interstitial,
                                                         NSError * error);
typedef void (^APDMyTargetModalAdLoadingBlock)(NSDictionary * loadingParameters,
                                               id<APDAdapterDataSource> dataSource,
                                               APDMyTargetModalAdLoadingCompletionBlock);


@interface APDMyTargetModalAdapter : APDMyTargetAdapter

@property (nonatomic, copy) APDMyTargetModalBlock didPresent;
@property (nonatomic, copy) APDMyTargetModalBlock didDismiss;
@property (nonatomic, copy) APDMyTargetModalBlock didFinish;

- (APDMyTargetModalAdLoadingBlock)loadModalAd;

- (void)presentModal:(UIViewController *)viewController
          completion:(void(^)(MTRGInterstitialAd *))completion;

@end

