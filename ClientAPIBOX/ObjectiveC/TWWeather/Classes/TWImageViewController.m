//
// TWImageViewController.m
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

#import "TWImageViewController.h"
#import "TWWeatherAppDelegate.h"

@implementation TWImageViewController

- (void)dealloc
{
	[_image release];
	_image = nil;
	[self viewDidUnload];
    [super dealloc];
}
- (void)viewDidUnload
{
	self.imageView = nil;
	self.view = nil;
}
- (void)loadView 
{
	UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)] autorelease];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;	
	scrollView.backgroundColor = [UIColor blackColor];
	scrollView.canCancelContentTouches = NO;
	scrollView.clipsToBounds = YES; 
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.minimumZoomScale = 1;
	scrollView.maximumZoomScale = 2.5;
	scrollView.scrollEnabled = YES;
	scrollView.delegate = self;
	scrollView.userInteractionEnabled = YES;
	
	self.view = scrollView;
	
	UIImageView *imageView = [[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
	imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	imageView.backgroundColor = [UIColor blackColor];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.imageView = imageView;
	[scrollView setContentSize:self.imageView.frame.size];
	[scrollView addSubview:imageView];
}

#pragma mark UIViewContoller Methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.imageView.image = self.image;
	[(UIScrollView *)self.view setContentSize:_imageView.frame.size];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(navBarAction:)];
	self.navigationItem.rightBarButtonItem = item;
	[item release];		
}
- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
//	self.navigationController.navigationBar.translucent = YES;
}
- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//	self.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidDisappear:(BOOL)animated 
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)setImage:(UIImage *)image
{
	id tmp = _image;
	_image = [image retain];
	[tmp release];
	self.imageView.image = image;
}
- (UIImage *)image
{
	return _image;
}

#pragma mark -

- (IBAction)navBarAction:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Copy", @""), NSLocalizedString(@"Share via Facebook", @""), NSLocalizedString(@"Save", @""), nil];
	[actionSheet showInView:[self view]];
	[actionSheet release];
}
- (void)shareImageViaFacebook
{
	if ([[TWWeatherAppDelegate sharedDelegate] confirmFacebookLoggedIn]) {
		FBStreamDialog *dialog = [[[FBStreamDialog alloc] init] autorelease];
		dialog.delegate = [TWWeatherAppDelegate sharedDelegate];
		dialog.userMessagePrompt = self.title;
		NSLog(@"self.imageURL :%@", [self.imageURL  description]);
		NSString *URLString = [self.imageURL absoluteString];
		NSString *attachment = [NSString stringWithFormat:@"{\"name\":\"%@\",\"media\":[{\"type\":\"image\", \"src\":\"%@\", \"href\":\"%@\"}]}", self.title, URLString, URLString];
		NSLog(@"attachment:%@", [attachment description]);
		dialog.attachment = attachment;
		[dialog show];
	}
}
- (void)copy
{
	UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
	pasteBoard.image = self.image;
}

- (void)_image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo
{
	NSString *alertTitle = nil;
	NSString *message = nil;
	
	if (error) {
		alertTitle = NSLocalizedString(@"Failed to save your image.", @"");
		message = [error localizedDescription];
	}
	else {
		alertTitle = NSLocalizedString(@"The image is saved!", @"");
		message = @"";
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)save
{
	UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(_image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0:
			[self copy];
			break;
		case 1:
			[self shareImageViaFacebook];
			break;			
		case 2:
			[self save];
			break;
		default:
			break;
	}
}

#pragma mark -

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return _imageView;
}

@synthesize imageView = _imageView;
@synthesize imageURL = _imageURL;	
@dynamic image;

@end
