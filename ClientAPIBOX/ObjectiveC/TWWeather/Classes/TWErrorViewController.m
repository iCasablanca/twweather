//
// TWErrorViewController.m
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

#import "TWErrorViewController.h"


@implementation TWErrorViewController

- (void)dealloc
{
	[_error release];
	[self viewDidUnload];
    [super dealloc];
}
- (void)viewDidUnload
{
	[textLabel release];
	textLabel = nil;
	self.view = nil;
}

#pragma mark UIViewContoller Methods

- (void)loadView 
{
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
	view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	view.backgroundColor = [UIColor colorWithHue:1.0 saturation:0.0 brightness:0.9 alpha:1.0];
	self.view = view;
	self.title = NSLocalizedString(@"Error!", @"");
	
	textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 200)];
	textLabel.text = @"";
	textLabel.textAlignment = UITextAlignmentCenter;
	textLabel.numberOfLines = 10;
	textLabel.font = [UIFont boldSystemFontOfSize:18.0];
	textLabel.backgroundColor = [UIColor colorWithHue:1.0 saturation:0.0 brightness:0.9 alpha:1.0];
	textLabel.shadowColor = [UIColor whiteColor];
	textLabel.shadowOffset = CGSizeMake(0, 2);
	
	[self.view addSubview:textLabel];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	NSString *description = [_error localizedDescription];
	if (description) {
		textLabel.text = description;
	}
	else {
		textLabel.text = @"Error!";
	}
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)setError:(NSError *)error
{
	id tmp = _error;
	_error = [error retain];
	[tmp release];
	NSString *description = [error localizedDescription];
	textLabel.text = description;
}

- (NSError *)error
{
	return _error;
}

@dynamic error;

@end
