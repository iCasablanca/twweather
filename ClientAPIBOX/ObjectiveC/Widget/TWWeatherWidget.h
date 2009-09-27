//
//  TWWeatherWidget.h
//  WeatherWidget
//
//  Created by zonble on 2009/09/13.
//  Copyright 2009 Lithoglyph Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"

@interface TWWeatherWidget : NSObject
{
	WebView *_webView;
}

- (NSArray *)locations;

@end
