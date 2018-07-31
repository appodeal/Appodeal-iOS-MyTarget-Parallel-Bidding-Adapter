//
//  APDPBMyTargetModalAdapter.h
//  APDMyTargetAdapter
//
//  Created by Lozhkin Ilya on 7/4/18.
//  Copyright © 2018 Appodeal, Inc. All rights reserved.
//

#import "APDMyTargetModalAdapter.h"
#import <AppodealAdExchangeSDK/AppodealAdExchangeSDK.h>

@interface APDPBMyTargetModalAdapter : APDMyTargetModalAdapter <ADXFullscreenAdapter>

@property (nonatomic, weak) id<ADXFullscreenAdapterDelegate> delegate;
@property (nonatomic, assign, readwrite) BOOL rewarded;

@end
