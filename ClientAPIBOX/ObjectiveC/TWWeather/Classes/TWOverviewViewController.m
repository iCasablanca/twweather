//
//  TWOverviewViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//  Copyright 2009 Lithoglyph Inc.. All rights reserved.
//

#import "TWOverviewViewController.h"


@implementation TWOverviewViewController

- (void)dealloc
{
	[_text release];
	[self viewDidUnload];
    [super dealloc];
}
- (void)viewDidUnload
{
//	[super viewDidLoad];
	self.view = nil;
	self.textView = nil;
}

#pragma mark UIViewContoller Methods

- (void)loadView 
{
	UITextView *theTexView = [[[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
	theTexView.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	theTexView.editable = NO;
	theTexView.font = [UIFont systemFontOfSize:18.0];
	self.textView = theTexView;
	self.view = theTexView;
	if (![self.title length]) {
		self.title = @"關心天氣";
	}
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

@synthesize textView;
@dynamic text;

@end
