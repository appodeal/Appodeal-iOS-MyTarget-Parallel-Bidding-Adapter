//
//  APDMyTargetNativeAdRenderer.h
//
//  Copyright © 2017 Appodeal, Inc. All rights reserved.
//

#import <Appodeal/AppodealPrivateHeaders.h>

@interface APDMyTargetNativeAdRenderer : NSObject <APDNativeAdViewRenderer>

@property (nonatomic, weak)id<APDNativeAdViewRendererDelegate> delegate;

@end
