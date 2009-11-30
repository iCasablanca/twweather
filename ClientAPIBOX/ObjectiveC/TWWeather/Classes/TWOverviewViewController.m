//
//  TWOverviewViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//  Copyright 2009 Lithoglyph Inc.. All rights reserved.
//

#import "TWOverviewViewController.h"
#import "TWWeatherAppDelegate.h"

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

- (IBAction)navBarAction:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Copy", @""), NSLocalizedString(@"Share via Facebook", @""), nil];
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
}


@synthesize textView;
@dynamic text;

@end
