//
// TWOverviewViewController.m
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

#import "TWOverviewViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWPlurkComposer.h"

@implementation TWOverviewViewController

- (void)dealloc
{
	[_text release];
	_text = nil;
	[self viewDidUnload];
    [super dealloc];
}
- (void)viewDidUnload
{
	[super viewDidLoad];
	self.view = nil;
	self.textView = nil;
}

#pragma mark UIViewContoller Methods

- (void)loadView 
{
	UITextView *theTextView = [[[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
	theTextView.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	theTextView.editable = NO;
	theTextView.font = [UIFont systemFontOfSize:18.0];
	self.textView = theTextView;
	self.view = theTextView;
	if (![self.title length]) {
		self.title = @"關心天氣";
	}
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(navBarAction:)];
	self.navigationItem.rightBarButtonItem = item;
	[item release];	
}
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.textView.text = _text;	
}
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)setText:(NSString *)text
{
	id tmp = _text;
	_text = [text retain];
	[tmp release];

	self.textView.text = text;
}
- (void)copy
{
	[[UIPasteboard generalPasteboard] setString:_text];
}

- (void)shareViaFacebook
{
	if ([[TWWeatherAppDelegate sharedDelegate] confirmFacebookLoggedIn]) {
		FBStreamDialog *dialog = [[[FBStreamDialog alloc] init] autorelease];
		dialog.delegate = [TWWeatherAppDelegate sharedDelegate];
		
		NSString *feedTitle = [self title];
		NSString *description = [_text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		NSString *attachment = [NSString stringWithFormat:@"{\"name\":\"%@\", \"description\":\"%@\"}", feedTitle, description];
		dialog.attachment = attachment;
		dialog.userMessagePrompt = feedTitle;
		[dialog show];
	}
}

- (void)shareViaPlurk
{
	NSString *feedTitle = [self title];
	NSString *description = [_text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	NSString *text = [NSString stringWithFormat:@"%@ %@", feedTitle, description];
	[[TWPlurkComposer sharedComposer] showWithController:self text:text];
}

- (IBAction)navBarAction:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Copy", @""), NSLocalizedString(@"Share via Facebook", @""), NSLocalizedString(@"Share via Plurk", @""), nil];
	[actionSheet showInView:[self view]];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		[self copy];
	}
	else if (buttonIndex == 1) {
		[self shareViaFacebook];
	}
	else if (buttonIndex == 2) {
		[self shareViaPlurk];
	}
	
}


@synthesize textView;
@dynamic text;

@end
