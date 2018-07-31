//
//  APDMyTargetVideoAdapter.h
//
//  Copyright © 2016 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetModalAdapter.h"
#import <Appodeal/AppodealPrivateHeaders.h>

@interface APDMyTargetVideoAdapter : APDMyTargetModalAdapter <APDSkippableVideoAdapter, APDRewardedVideoAdapter>

@property (weak, nonatomic) id<APDVideoAdapterDelegate> delegate;
@property (weak, nonatomic) id<APDAdapterDataSource> dataSource;

@end
