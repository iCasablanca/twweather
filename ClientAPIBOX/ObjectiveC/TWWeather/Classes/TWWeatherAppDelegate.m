//
//  TWWeatherAppDelegate.m
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//  Copyright Lithoglyph Inc. 2009. All rights reserved.
//

#import "TWWeatherAppDelegate.h"
#import "RootViewController.h"


@implementation TWWeatherAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

