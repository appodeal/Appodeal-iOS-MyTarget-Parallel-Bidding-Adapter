//
//  APDMyTargetInterstitialAdAdapter.h
//
//  Copyright © 2015 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetModalAdapter.h"
#import <Appodeal/AppodealPrivateHeaders.h>

@interface APDMyTargetInterstitialAdAdapter : APDMyTargetModalAdapter <APDInterstitialAdAdapter>

@property (weak, nonatomic) id<APDInterstitialAdAdapterDelegate> delegate;
@property (weak, nonatomic) id<APDAdapterDataSource> dataSource;

@end
