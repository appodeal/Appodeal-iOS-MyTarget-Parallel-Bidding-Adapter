//
//  APDMyTargetAdNetwork.h
//
//  Copyright © 2015 Appodeal, Inc. All rights reserved.
//

#import <Appodeal/AppodealPrivateHeaders.h>
#import <AppodealAdExchangeSDK/AppodealAdExchangeSDK.h>

@interface APDMyTargetAdNetwork : APDAdNetwork <APDParallelBiddingNetwork, ADXNetwork>

@property (nonatomic, weak) id <APDAdapterDataSource> dataSource;

@end
