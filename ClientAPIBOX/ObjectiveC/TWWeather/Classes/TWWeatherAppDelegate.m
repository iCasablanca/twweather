//
//  TWWeatherAppDelegate.m
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import "TWWeatherAppDelegate.h"
#import "RootViewController.h"

@implementation TWWeatherAppDelegate

- (void)dealloc 
{
	[navigationController release];
	[window release];
	[super dealloc];
}


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{    
    // Override point for customization after app launch    
	RootViewController *rootController = [[RootViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:rootController];
	[rootController release];
	self.navigationController = aNavigationController;
	[aNavigationController release];	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application 
{
	// Save data if appropriate
}

@synthesize window;
@synthesize navigationController;

@end

