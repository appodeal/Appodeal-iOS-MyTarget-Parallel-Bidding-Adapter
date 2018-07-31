//
//  APDPBMyTargetBannerAdapter.h
//  APDMyTargetAdapter
//
//  Created by Lozhkin Ilya on 7/4/18.
//  Copyright © 2018 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetViewAdapter.h"
#import <AppodealAdExchangeSDK/AppodealAdExchangeSDK.h>

@interface APDPBMyTargetBannerAdapter : APDMyTargetAdViewAdapter <ADXBannerAdapter>

@property (nonatomic, weak) id <ADXBannerAdapterDelegate> delegate;

@end

