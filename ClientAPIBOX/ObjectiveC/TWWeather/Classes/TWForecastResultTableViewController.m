//
// TWForecastResultTableViewController.m
//
// Copyright (c) 2009 - 2010 Weizhong Yang (http://zonble.net)
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

#import "TWForecastResultTableViewController.h"
#import "TWForecastResultCell.h"
#import "TWWeekResultTableViewController.h"
#import "TWErrorViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWLoadingCell.h"
#import "TWAPIBox.h"
#import "TWSocialComposer.h"

@implementation TWForecastResultTableViewController

- (void)dealloc 
{
	self.forecastArray = nil;
	self.weekLocation = nil;
	self.weekDictionary = nil;
    [super dealloc];
}

#pragma mark UIViewContoller Methods

- (void)viewDidLoad
{
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(navBarAction:)];
	self.navigationItem.rightBarButtonItem = item;
	[item release];	
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[TWAPIBox sharedBox] cancelAllRequestWithDelegate:self];
}
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
}

- (IBAction)navBarAction:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Share via Facebook", @""), NSLocalizedString(@"Share via Plurk", @""), NSLocalizedString(@"Share via Twitter", @""), nil];
	[actionSheet showInView:[self view]];
	[actionSheet release];
}

- (NSString *)_feedDescription
{
	NSMutableString *description = [NSMutableString string];
	for (NSDictionary *forecast in forecastArray) {
		[description appendFormat:@"※ %@", [forecast objectForKey:@"title"]];
		[description appendFormat:@"(%@ - %@) ", [forecast objectForKey:@"beginTime"], [forecast objectForKey:@"endTime"]];
		[description appendFormat:@"%@ ", [forecast objectForKey:@"description"]];
		[description appendFormat:@"降雨機率：%@ ", [forecast objectForKey:@"rain"]];
		[description appendFormat:@"氣溫：%@ ", [forecast objectForKey:@"temperature"]];
	}
	return description;
}

- (void)shareViaFacebook
{
	if ([[TWWeatherAppDelegate sharedDelegate] confirmFacebookLoggedIn]) {
		FBStreamDialog *dialog = [[[FBStreamDialog alloc] init] autorelease];
		dialog.delegate = [TWWeatherAppDelegate sharedDelegate];
		
		NSString *feedTitle = [NSString stringWithFormat:@"%@ 四十八小時天氣預報", [self title]];
		NSString *description = [self _feedDescription];
		NSString *attachment = [NSString stringWithFormat:@"{\"name\":\"%@\", \"description\":\"%@\"}", feedTitle, description];
		dialog.attachment = attachment;
		dialog.userMessagePrompt = feedTitle;
		[dialog show];
	}
}

- (void)shareViaSocialComposer
{
	NSString *feedTitle = [NSString stringWithFormat:@"%@ 四十八小時天氣預報", [self title]];
	NSString *description = [self _feedDescription];
	NSString *text = [NSString stringWithFormat:@"%@ %@", feedTitle, description];

	[[TWSocialComposer sharedComposer] showWithText:text];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		[self shareViaFacebook];
	}
	else if (buttonIndex == 1) {
		[TWSocialComposer sharedComposer].mode = TWSocialComposerPlurkMode;
		[self shareViaSocialComposer];
	}
	else if (buttonIndex == 2) {
		[TWSocialComposer sharedComposer].mode = TWSocialComposerTwitterMode;
		[self shareViaSocialComposer];
	}
}

#pragma mark -
#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (weekLocation) {
		return 2;
	}
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return [forecastArray count];
	}
	else if (section == 1) {
		return 1;
	}	
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	static NSString *CellIdentifier = @"Cell";
	static NSString *NormalIdentifier = @"NormalCell";
	if (indexPath.section == 0) {
		TWForecastResultCell *cell = (TWForecastResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[TWForecastResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		NSDictionary *dictionary = [forecastArray objectAtIndex:indexPath.row];
		cell.title = [dictionary objectForKey:@"title"];
		cell.description = [dictionary objectForKey:@"description"];
		cell.rain = [dictionary objectForKey:@"rain"];
		cell.temperature = [dictionary objectForKey:@"temperature"];
		NSString *beginTimeString = [dictionary objectForKey:@"beginTime"];
		NSDate *beginDate = [[TWAPIBox sharedBox] dateFromString:beginTimeString];
		cell.beginTime = [[TWAPIBox sharedBox] shortDateTimeStringFromDate:beginDate];
		NSString *endTimeString = [dictionary objectForKey:@"endTime"];
		NSDate *endDate = [[TWAPIBox sharedBox] dateFromString:endTimeString];
		cell.endTime = [[TWAPIBox sharedBox] shortDateTimeStringFromDate:endDate];
		
		NSString *imageString = [[TWWeatherAppDelegate sharedDelegate] imageNameWithTimeTitle:cell.title description:cell.description ];
		cell.weatherImage = [UIImage imageNamed:imageString];
		
		[cell setNeedsDisplay];
		return cell;
	}
	else if (indexPath.section == 1) {
		TWLoadingCell *cell = (TWLoadingCell *)[tableView dequeueReusableCellWithIdentifier:NormalIdentifier];
		if (cell == nil) {
			cell = [[[TWLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalIdentifier] autorelease];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.text = @"一週預報";
		
		if (isLoadingWeek) {
			[cell startAnimating];
		}
		else {
			[cell stopAnimating];
		}
		
		return cell;
	}	
	return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return 130.0;
	}
	return 45.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1) {
		if (weekDictionary) {
			[self pushWeekViewController];
			return;
		}
		isLoadingWeek = YES;
		[self.tableView reloadData];
		[[TWAPIBox sharedBox] fetchWeekWithLocationIdentifier:self.weekLocation delegate:self userInfo:nil];
	}
}

#pragma mark -
#pragma mark TWWeatherAPI delegate

- (void)pushWeekViewController
{
	TWWeekResultTableViewController *controller = [[TWWeekResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.title = [self.weekDictionary objectForKey:@"locationName"];
	controller.forecastArray = [self.weekDictionary objectForKey:@"items"];
	NSString *dateString = [self.weekDictionary objectForKey:@"publishTime"];
	NSDate *date = [[TWAPIBox sharedBox] dateFromShortString:dateString];
	controller.publishTime = [[TWAPIBox sharedBox] shortDateTimeStringFromDate:date];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}
- (void)pushErrorViewWithError:(NSError *)error
{
	TWErrorViewController *controller = [[TWErrorViewController alloc] init];
	controller.error = error;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchWeek:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	isLoadingWeek = NO;
	[self.tableView reloadData];

	if ([result isKindOfClass:[NSDictionary class]]) {
		self.weekDictionary = result;
		[self pushWeekViewController];
	}
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWeekWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	isLoadingWeek = NO;
	[self.tableView reloadData];
	
	[self pushErrorViewWithError:error];
}


@synthesize forecastArray;
@synthesize weekLocation;
@synthesize weekDictionary;

@end

