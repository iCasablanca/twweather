//
//  TWTwitterEngine.m
//  TWWeather
//
//  Created by zonble on 1/19/10.
//  Copyright 2010 Lithoglyph Inc.. All rights reserved.
//

#import "TWTwitterEngine.h"
#import "TWWeatherAppDelegate.h"

@implementation TWTwitterEngine

- (void)setLoggedIn:(BOOL)flag
{
	isLoggedIn = flag;
}
- (BOOL)isLoggedIn
{
	return isLoggedIn;
}

@dynamic loggedIn;

@end
