//
// TWThreeDaySeaResultTableViewController.m
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

#import "TWThreeDaySeaResultTableViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWThreeDaySeaCell.h"
#import "TWAPIBox.h"
#import "TWSocialComposer.h"

@implementation TWThreeDaySeaResultTableViewController

- (void)dealloc 
{
	[forecastArray release];
	[publishTime release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)viewDidLoad
{
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(navBarAction:)];
	self.navigationItem.rightBarButtonItem = item;
	[item release];	
}

#pragma mark -

- (IBAction)navBarAction:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Share via Facebook", @""), NSLocalizedString(@"Share via Plurk", @""), nil];
	[actionSheet showInView:[self view]];
	[actionSheet release];
}

- (NSString *)_feedDescription
{
	NSMutableString *description = [NSMutableString string];
	for (NSDictionary *forecast in forecastArray) {
		[description appendFormat:@"※ %@ ", [forecast objectForKey:@"date"]];
		[description appendFormat:@"%@ ", [forecast objectForKey:@"description"]];
		[description appendFormat:@"%@ ", [forecast objectForKey:@"wind"]];
		[description appendFormat:@"%@ ", [forecast objectForKey:@"windScale"]];
		[description appendFormat:@"%@ ", [forecast objectForKey:@"wave"]];
	}
	[description appendFormat:@" 發佈時間%@", publishTime];
	return description;
}

- (void)shareViaFacebook
{
	if ([[TWWeatherAppDelegate sharedDelegate] confirmFacebookLoggedIn]) {
		FBStreamDialog *dialog = [[[FBStreamDialog alloc] init] autorelease];
		dialog.delegate = [TWWeatherAppDelegate sharedDelegate];
		
		NSString *feedTitle = [NSString stringWithFormat:@"%@ 三天漁業預報", [self title]];
		NSString *description = [self _feedDescription];	
		
		NSString *attachment = [NSString stringWithFormat:@"{\"name\":\"%@\", \"description\":\"%@\"}", feedTitle, description];
		dialog.attachment = attachment;
		dialog.userMessagePrompt = feedTitle;
		[dialog show];
	}
}

- (void)shareViaPlurk
{
	NSString *feedTitle = [NSString stringWithFormat:@"%@ 三天漁業預報", [self title]];
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
		[self shareViaPlurk];
	}
	
}

#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [forecastArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    TWThreeDaySeaCell *cell = (TWThreeDaySeaCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TWThreeDaySeaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	NSDictionary *dictionary = [forecastArray objectAtIndex:indexPath.row];
	NSString *dateString = [dictionary objectForKey:@"date"];
	NSDate *date = [[TWAPIBox sharedBox] dateFromShortString:dateString];
	cell.date = [[TWAPIBox sharedBox] shortDateStringFromDate:date];	
	cell.description = [dictionary objectForKey:@"description"];
	cell.wind = [dictionary objectForKey:@"wind"];
	cell.windScale = [dictionary objectForKey:@"windScale"];
	cell.wave = [dictionary objectForKey:@"wave"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSString *imageString = [[TWWeatherAppDelegate sharedDelegate] imageNameWithTimeTitle:@"" description:cell.description ];
	cell.weatherImage = [UIImage imageNamed:imageString];

	[cell setNeedsDisplay];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 120.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *time = [NSString stringWithFormat:@"發布時間：%@", publishTime];
	return time;
}

@synthesize forecastArray;
@synthesize publishTime;

@end

