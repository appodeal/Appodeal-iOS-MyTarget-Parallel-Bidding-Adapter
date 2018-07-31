//
//  APDMyTargetBannerAdapter.h
//
//  Copyright © 2015 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetViewAdapter.h"
#import <Appodeal/AppodealPrivateHeaders.h>

@interface APDMyTargetBannerAdapter : APDMyTargetAdViewAdapter <APDBannerAdapter>

@property (weak, nonatomic) id<APDBannerAdapterDelegate> delegate;
@property (weak, nonatomic) id<APDBannerAdapterDataSource> dataSource;

@end
