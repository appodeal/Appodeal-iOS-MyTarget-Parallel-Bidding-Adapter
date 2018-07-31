//
//  APDMyTargetNativeServiceAdAdapter.h
//
//  Copyright © 2016 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetViewAdapter.h"
#import <Appodeal/AppodealPrivateHeaders.h>

@interface APDMyTargetNativeAdServiceAdapter : APDMyTargetAdViewAdapter <APDNativeAdService>

@property (weak, nonatomic) id<APDNativeAdServiceDelegate> delegate;
@property (weak, nonatomic) id<APDNativeAdServiceDataSource> dataSource;

@end
