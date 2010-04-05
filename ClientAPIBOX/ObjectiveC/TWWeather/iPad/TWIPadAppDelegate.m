//
//  TWIPadAppDelegate.m
//  TWWeather
//
//  Created by zonble on 4/5/10.
//  Copyright 2010 Lithoglyph Inc. All rights reserved.
//

#import "TWIPadAppDelegate.h"
#import "TWIPadSourceListTableVoewController.h"
#import "TWIPadMainViewController.h"

@implementation TWIPadAppDelegate

- (void) dealloc
{
	[window release];
	[splitViewController release];
	[sourceListTableViewController release];
	[mainViewController release];
	[super dealloc];
}


- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	UIWindow *newWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	newWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.window = [newWindow autorelease];
	
	if (!sourceListTableViewController) {
		sourceListTableViewController = [[TWIPadSourceListTableVoewController alloc] initWithStyle:UITableViewStyleGrouped];
	}
	if (!mainViewController) {
		mainViewController = [[TWIPadMainViewController alloc] initWithNibName:NSStringFromClass([TWIPadMainViewController class]) bundle:[NSBundle mainBundle]];
	}
	if (!splitViewController) {
		Class splitViewClass = NSClassFromString(@"UISplitViewController");
		if (splitViewClass) {
			splitViewController = [[splitViewClass alloc] init];
			[splitViewController performSelector:@selector(setViewControllers:) withObject:[NSArray arrayWithObjects:sourceListTableViewController, mainViewController, nil]];
		}
	}
	
	[self.window addSubview:splitViewController.view];
	[self.window makeKeyAndVisible];
}

@synthesize window;
@synthesize splitViewController;
@synthesize sourceListTableViewController;
@synthesize mainViewController;


@end
