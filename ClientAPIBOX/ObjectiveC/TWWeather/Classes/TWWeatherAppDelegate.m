//
//  TWWeatherAppDelegate.m
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import "TWWeatherAppDelegate.h"
#import "TWRootViewController.h"
#import "TWFavoriteTableViewController.h"
#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"

@implementation TWWeatherAppDelegate

+ (TWWeatherAppDelegate*)sharedDelegate
{
	return (TWWeatherAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)dealloc 
{
	[tabBarController release];
	[window release];
	[super dealloc];
}


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{   	
	UITabBarController *controller = [[UITabBarController alloc] init];
	controller.title = @"台灣天氣";
	self.tabBarController = controller;	
	[controller release];
	
	NSMutableArray *controllerArray = [NSMutableArray array];
	
	TWFavoriteTableViewController *favControlelr = [[TWFavoriteTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	favControlelr.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0] autorelease];	
	[controllerArray addObject:favControlelr];
	[favControlelr release];
	
	TWRootViewController *rootController = [[TWRootViewController alloc] initWithStyle:UITableViewStyleGrouped];
	rootController.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:1] autorelease];	
	[controllerArray addObject:rootController];
	[rootController release];

	self.tabBarController.viewControllers = controllerArray;
	
	UINavigationController *ourNavigationController = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];
	self.navigationController = ourNavigationController;
	[ourNavigationController release];
	
	[window addSubview:[self.navigationController view]];
    [window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
	// Save data if appropriate
}

- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated
{
	[self.navigationController pushViewController:controller animated:YES];
}

- (NSString *)imageNameWithTimeTitle:(NSString *)timeTitle description:(NSString *)description
{
	NSMutableString *string = [NSMutableString string];
	if ([timeTitle isEqualToString:[NSString stringWithUTF8String:"今晚至明晨"]] || [timeTitle isEqualToString:[NSString stringWithUTF8String:"明晚後天"]])
		[string setString:@"Night"];
	else
		[string setString:@"Day"];

	if ([description isEqualToString:[NSString stringWithUTF8String:"晴時多雲"]])
		[string appendString:@"SunnyCloudy"];
	else if ([description hasPrefix:[NSString stringWithUTF8String:"多雲時晴"]])
		[string appendString:@"CloudySunny"];
	else if ([description hasPrefix:[NSString stringWithUTF8String:"多雲時陰"]])
		[string appendString:@"CloudyGlommy"];
	else if ([description hasPrefix:[NSString stringWithUTF8String:"多雲短暫雨"]])
		[string appendString:@"GloomyRainy"];
	else if ([description isEqualToString:[NSString stringWithUTF8String:"多雲"]])
		[string appendString:@"Cloudy"];
	else if ([description hasPrefix:[NSString stringWithUTF8String:"陰天"]])
		[string appendString:@"Glommy"];	
	else if ([description hasPrefix:[NSString stringWithUTF8String:"陰"]])
		[string appendString:@"Glommy"];
	else if ([description hasPrefix:[NSString stringWithUTF8String:"晴天"]])
		[string appendString:@"Sunny"];
	else if ([description hasPrefix:[NSString stringWithUTF8String:"晴"]])
		[string appendString:@"Sunny"];
	else
		[string appendString:@"Rainy"];

	[string appendString:@".png"];
	return string;
}

@synthesize window;
@synthesize tabBarController;
@synthesize navigationController;

@end

