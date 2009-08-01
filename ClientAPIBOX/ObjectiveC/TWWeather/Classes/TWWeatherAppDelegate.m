//
//  TWWeatherAppDelegate.m
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import "TWWeatherAppDelegate.h"
#import "RootViewController.h"
#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"

NSString *TWCurrentForecastDidFetchNotification = @"TWCurrentForecastDidFetchNotification";
NSString *forecastOfCurrentLocationPreference = @"forecastOfCurrentLocationPreference";
NSString *currentLocationPreference = @"currentLocationPreference";

@implementation TWWeatherAppDelegate

+ (TWWeatherAppDelegate*)sharedDelegate
{
	return (TWWeatherAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)dealloc 
{
	[forecastOfCurrentLocation release];
	[navigationController release];
	[window release];
	[super dealloc];
}


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{    
	forecastOfCurrentLocation = nil;
	forecastOfCurrentLocation = [[NSUserDefaults standardUserDefaults] objectForKey:forecastOfCurrentLocationPreference];
	[self fetchForecastOFCurrentLocation];
	
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

- (void)fetchForecastOFCurrentLocation
{
	if (![[NSUserDefaults standardUserDefaults] objectForKey:currentLocationPreference]) {
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:currentLocationPreference];
	}	
	NSUInteger i = [[NSUserDefaults standardUserDefaults] integerForKey:currentLocationPreference];
	if (i >= [[[TWAPIBox sharedBox] forecastLocations] count]) {
		i = 0;
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:currentLocationPreference];
	}
	NSDictionary *dictionary = [[[TWAPIBox sharedBox] forecastLocations] objectAtIndex:i];
	NSString *identifier = [dictionary objectForKey:@"identifier"];	
	[[TWAPIBox sharedBox] fetchForecastWithLocationIdentifier:identifier delegate:self userInfo:nil];
}


#pragma mark -

- (void)APIBox:(TWAPIBox *)APIBox didFetchForecast:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	if ([result isKindOfClass:[NSDictionary class]]) {
		self.forecastOfCurrentLocation = result;
		[[NSUserDefaults standardUserDefaults] setObject:result forKey:forecastOfCurrentLocationPreference];
		[[NSNotificationCenter defaultCenter] postNotificationName:TWCurrentForecastDidFetchNotification object:forecastOfCurrentLocation userInfo:nil];
	}
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchForecastWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
}


@synthesize window;
@synthesize navigationController;
@synthesize forecastOfCurrentLocation;

@end

