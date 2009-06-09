//
//  TWWeatherAppDelegate.m
//  TWWeather
//
//  Created by zonble on 2009/1/12.
//  Copyright zonble.twbbs.org 2009. All rights reserved.
//

#import "TWWeatherAppDelegate.h"
#import "TWWeatherAPI.h"
#import "TWWeatherAPI+ForecastParser.h"
#import "ZBForecastsArrayController.h"
#import "ZBForecastPickerViewController.h"
#import "Reachability.h"

@implementation TWWeatherAppDelegate

- (void)dealloc 
{
	[_rootViewController release];	
	[_rootDictionary release];
	[_rootTitle release];
	[navigationController release];
	[window release];
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	[Reachability sharedReachability].hostName = @"www.cwb.gov.tw";
	
	_rootDictionary = nil;
	_rootTitle = [[NSString stringWithUTF8String:"正在取得網路資料…"] retain];
//	_rootViewController = [[RootViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
	_rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:[NSBundle mainBundle]];
	navigationController.viewControllers = [NSArray arrayWithObject:_rootViewController];
	[navigationController.navigationBar setTintColor:[UIColor grayColor]];
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];	
	[self updateRootForecast];

}

- (void)applicationWillTerminate:(UIApplication *)application 
{
	// Save data if appropriate
}

- (void)updateRootForecast
{	
	ZBForecastsArrayController *arrayController = [ZBForecastsArrayController new];
	NSArray *array = arrayController.array;
	NSInteger selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreferenceName];
	NSDictionary *d = [array objectAtIndex:selectedIndex];
	NSString *name = [d valueForKey:@"name"];
	NSString *URLString = [d valueForKey:@"URLString"];
	[[TWWeatherAPI sharedAPI] fetchForecastWithDelegate:self name:name URLString:URLString];
}
- (void)showLocationPicker
{
	ZBForecastPickerViewController *controller = [[ZBForecastPickerViewController alloc] initWithNibName:@"ZBForecastPickerViewController" bundle:[NSBundle mainBundle]];
	[self.navigationController presentModalViewController:controller animated:YES];
	[controller release];
}
- (void)hideLocationPicker
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)foreCastParserDidComplete:(TWWeatherAPI *)api name:(NSString *)name forecasts:(NSArray *)forecasts;
{
	if (![forecasts count]) {
		if ([self respondsToSelector:@selector(foreCastParserDidFail:)])
			[self performSelector:@selector(foreCastParserDidFail:) withObject:api];
		return;
	}
	NSDictionary *d = [forecasts objectAtIndex:0];
	id tmp = _rootDictionary;
	_rootDictionary = [d retain];
	[tmp release];
	
	tmp = _rootTitle;
	_rootTitle = [[NSString stringWithFormat:@"%@%@", name, [NSString stringWithUTF8String:"天氣預報"]] retain];	
	[tmp release];

	if (_rootViewController && _rootViewController.tableView)
		[_rootViewController.tableView reloadData];
}
- (void)foreCastParserDidFail:(TWWeatherAPI *)api
{
	NSLog(@"foreCastParserDidFail");
	[_rootDictionary release];
	_rootDictionary = nil;
	
	id tmp = _rootTitle;
	_rootTitle = [[NSString stringWithFormat:@"%@", [NSString stringWithUTF8String:"無法取得目前所在地天氣預報"]] retain];	
	[tmp release];
	
	if (_rootViewController && _rootViewController.tableView)
		[_rootViewController.tableView reloadData];
}

@synthesize window;
@synthesize navigationController;
@synthesize rootDictionary = _rootDictionary;
@synthesize rootViewController = _rootViewController;
@synthesize rootTitle = _rootTitle;

@end
