//
// TWNearSeaResultViewController.m
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

#import "TWNearSeaResultTableViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWNearSeaCell.h"
#import "TWSocialComposer.h"

@implementation TWNearSeaResultTableViewController

- (void)dealloc 
{
	[publishTime release];
	[description release];
	[validBeginTime release];
	[validEndTime release];
	[wave release];
	[waveLevel release];
	[wind release];
	[windScale release];
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
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Share via Facebook", @""), NSLocalizedString(@"Share via Plurk", @""), NSLocalizedString(@"Share via Twitter", @""), nil];
	[actionSheet showInView:[self view]];
	[actionSheet release];
}

- (NSString *)_feedDescription
{
	NSMutableString *attachmentDescription = [NSMutableString string];
	[attachmentDescription appendFormat:@"※ %@ - %@ ", self.validBeginTime, self.validEndTime];
	[attachmentDescription appendFormat:@"%@ ", self.description];
	[attachmentDescription appendFormat:@"%@ ", self.wave];
	[attachmentDescription appendFormat:@"%@ ", self.waveLevel];
	[attachmentDescription appendFormat:@"%@ ", self.wind];
	[attachmentDescription appendFormat:@"%@ ", self.windScale];
	return attachmentDescription;
}

- (void)shareViaFacebook
{
	if ([[TWWeatherAppDelegate sharedDelegate] confirmFacebookLoggedIn]) {
		FBStreamDialog *dialog = [[[FBStreamDialog alloc] init] autorelease];
		dialog.delegate = [TWWeatherAppDelegate sharedDelegate];
		
		NSString *feedTitle = [NSString stringWithFormat:@"%@ 天氣預報", [self title]];
		NSString *attachmentDescription = [self _feedDescription];				
		NSString *attachment = [NSString stringWithFormat:@"{\"name\":\"%@\", \"description\":\"%@\"}", feedTitle, attachmentDescription];
		dialog.attachment = attachment;
		dialog.userMessagePrompt = feedTitle;
		[dialog show];
	}
}
- (void)shareViaSocialComposer
{
	NSString *feedTitle = [NSString stringWithFormat:@"%@ 天氣預報", [self title]];
	NSString *attachmentDescription = [self _feedDescription];
	NSString *text = [NSString stringWithFormat:@"%@ %@", feedTitle, attachmentDescription];
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

#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    TWNearSeaCell *cell = (TWNearSeaCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TWNearSeaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.description = self.description;
	cell.validBeginTime = self.validBeginTime;
	cell.validEndTime = self.validEndTime;
	cell.wave = self.wave;
	cell.waveLevel = self.waveLevel;
	cell.wind = self.wind;
	cell.windScale = self.windScale;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSString *imageString = [[TWWeatherAppDelegate sharedDelegate] imageNameWithTimeTitle:@"" description:cell.description ];
	cell.imageView.image = [UIImage imageNamed:imageString];
	
	[cell setNeedsDisplay];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 320.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *time = [NSString stringWithFormat:@"發布時間：%@", publishTime];
	return time;
}

@synthesize description;
@synthesize publishTime;
@synthesize validBeginTime;
@synthesize validEndTime;
@synthesize wave;
@synthesize waveLevel;
@synthesize wind;
@synthesize windScale;

@end
