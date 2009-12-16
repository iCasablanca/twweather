//
// TWWeatherAppDelegate.m
//
// Copyright (c) 2009 Weizhong Yang (http://zonble.net)
// All Rights Reserved
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of Weizhong Yang (zonble) nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY WEIZHONG YANG ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL WEIZHONG YANG BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "TWWeatherAppDelegate.h"
#import "TWWeatherAppDelegate+BGM.h"
#import "TWRootViewController.h"
#import "TWMoreViewController.h"
#import "TWFavoriteTableViewController.h"
#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"
#import "TWCommonHeader.h"

@implementation TWWeatherAppDelegate

+ (TWWeatherAppDelegate*)sharedDelegate
{
	return (TWWeatherAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)dealloc 
{
	[tabBarController release];
	[window release];
	[audioPlayer release];
	[facebookSession.delegates removeObject:self];
	[facebookSession release];
	[super dealloc];
}


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{  
	facebookSession = [[FBSession sessionForApplication:API_KEY secret:SECRET delegate:self] retain];
	[facebookSession resume];
	 
	audioPlayer = nil;
	window.backgroundColor = [UIColor blackColor];

	UITabBarController *controller = [[UITabBarController alloc] init];
	
	NSBundle *bundle = [NSBundle mainBundle];
	NSDictionary *loaclizedDictionary = [bundle localizedInfoDictionary];
	controller.title = [loaclizedDictionary objectForKey:@"CFBundleDisplayName"];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleBordered target:nil action:NULL];
	controller.navigationItem.backBarButtonItem = item;
	[item release];
	
	self.tabBarController = controller;	
	[controller release];
	
	NSMutableArray *controllerArray = [NSMutableArray array];
	
	TWFavoriteTableViewController *favControlelr = [[TWFavoriteTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	favControlelr.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0] autorelease];	
	[controllerArray addObject:favControlelr];
	[favControlelr release];
	
	TWRootViewController *rootController = [[TWRootViewController alloc] initWithStyle:UITableViewStylePlain];
	rootController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Forecasts", @"") image:[UIImage imageNamed:@"forecasts.png"] tag:1] autorelease];
	[controllerArray addObject:rootController];
	[rootController release];

	TWMoreViewController *moreController = [[TWMoreViewController alloc] initWithStyle:UITableViewStyleGrouped];
	moreController.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:2] autorelease];	
	[controllerArray addObject:moreController];
	[moreController release];
	
	self.tabBarController.viewControllers = controllerArray;
	
	UINavigationController *ourNavigationController = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];
	self.navigationController = ourNavigationController;
	[ourNavigationController release];
	
	[window addSubview:[self.navigationController view]];
    [window makeKeyAndVisible];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:TWBGMPreferencen]) {
		[self startPlayingBGM];
	}
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

- (BOOL)confirmFacebookLoggedIn
{
	if (!facebookSession.isConnected) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You did not connect to Facebook.", @"") message:NSLocalizedString(@"Do you want to connect now?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:NSLocalizedString(@"Connect", @""), nil];
		[alertView show];
		[alertView release];
	}
	return facebookSession.isConnected;
}

- (void)dialogDidSucceed:(FBDialog*)dialog
{
	if ([dialog isKindOfClass:[FBLoginDialog class]]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Successfully connected on Facebook!", @"") message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
		[alert show];
		[alert release];		
	}
}
- (void)dialogDidCancel:(FBDialog*)dialog
{
}
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError*)error
{
	if ([dialog isKindOfClass:[FBLoginDialog class]]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to post on Facebook!", @"") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void)_showFacebookLoginViewWithDelay
{
	FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:facebookSession] autorelease];
	dialog.delegate = self;
	[dialog show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		[self performSelector:@selector(_showFacebookLoginViewWithDelay) withObject:nil afterDelay:0.2];
	}
}

#pragma mark facebookSession

- (void)session:(FBSession*)session didLogin:(FBUID)uid
{
}
- (void)sessionDidNotLogin:(FBSession*)session
{
}
- (void)session:(FBSession*)session willLogout:(FBUID)uid
{
}
- (void)sessionDidLogout:(FBSession*)session
{
}


@synthesize window;
@synthesize tabBarController;
@synthesize navigationController;
@synthesize facebookSession;

@end
