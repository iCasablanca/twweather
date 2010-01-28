//
// TWImageViewController.m
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

#import "ObjectivePlurk.h"
#import "TWSocialComposer.h"
#import "TWImageViewController.h"
#import "TWWeatherAppDelegate.h"

@implementation TWImageViewController

#pragma mark Routines

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
	[loadingView release];
	loadingView = nil;
}

#pragma mark UIViewContoller Methods

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
	
	loadingView = [[TWLoadingView alloc] initWithFrame:CGRectMake(100, 100, 120, 120)];	
}
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
}
- (void)viewWillDisappear:(BOOL)animated 
{
	[[ObjectivePlurk sharedInstance] cancelAllRequest];
	
	if (!pushingPlurkComposer) {	
		self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
		[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
	}
	pushingPlurkComposer = NO;
	
	[super viewWillDisappear:animated];	
}

#pragma mark -
#pragma mark Getters/Setters

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
#pragma mark Actions

- (IBAction)navBarAction:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Copy", @""), NSLocalizedString(@"Share via Facebook", @""), NSLocalizedString(@"Share via Plurk", @""), NSLocalizedString(@"Save", @""), nil];
	[actionSheet showInView:[self view]];
	[actionSheet release];
}
- (void)shareImageViaFacebook
{
	if ([[TWWeatherAppDelegate sharedDelegate] confirmFacebookLoggedIn]) {
		
		NSMutableDictionary *args = [[[NSMutableDictionary alloc] init] autorelease];
		[args setObject:self.title forKey:@"caption"];		
		FBRequest *uploadPhotoRequest = [FBRequest requestWithDelegate:self];
		NSData *data = UIImagePNGRepresentation(_image);
		[uploadPhotoRequest call:@"photos.upload" params:args dataParam:data];
		return;		
	}
}
- (void)shareImageViaPlurk
{
	if (![[ObjectivePlurk sharedInstance] isLoggedIn]) {
		[[TWSocialComposer sharedComposer] showLoginAlert];
		return;
	}	
	NSString *tmpFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.png"];
	[UIImagePNGRepresentation(_image) writeToFile:tmpFile atomically:YES];
	[self showLoadingView];
	[[ObjectivePlurk sharedInstance] uploadPicture:tmpFile delegate:self userInfo:nil];
	
}
- (void)doCopy
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

- (void)showLoadingView
{
	[self.view addSubview:loadingView];
	[loadingView startAnimating];
	self.view.userInteractionEnabled = NO;
}
- (void)hideLoadingView
{
//	[loadingView removeFromSuperview];
	[loadingView stopAnimating];
	self.view.userInteractionEnabled = YES;
}

#pragma mark -
#pragma mark UIActionSheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0:
			[self doCopy];
			break;
		case 1:
			[self shareImageViaFacebook];
			break;			
		case 2:
			[self shareImageViaPlurk];
			break;						
		case 3:
			[self save];
			break;
		default:
			break;
	}
}

#pragma mark UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return _imageView;
}

#pragma mark -
#pragma mark Facebook Connect Request delegate methods

- (void)requestLoading:(FBRequest*)request
{
	[self showLoadingView];
}
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response
{
}
- (void)request:(FBRequest*)request didLoad:(id)result
{
	[self hideLoadingView];	

	FBStreamDialog *dialog = [[[FBStreamDialog alloc] init] autorelease];
	dialog.delegate = [TWWeatherAppDelegate sharedDelegate];
	dialog.userMessagePrompt = self.title;
	
	NSString *name = [result objectForKey:@"caption"];
	NSString *src = [result objectForKey:@"src_big"];
	NSString *href = [result objectForKey:@"link"];
	
	NSString *attachment = [NSString stringWithFormat:@"{\"name\":\"%@\",\"media\":[{\"type\":\"image\", \"src\":\"%@\", \"href\":\"%@\"}]}", name, src, href];
	dialog.attachment = attachment;
	[dialog show];	
}
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
	[self hideLoadingView];	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unable to upload image to Facebook.", @"") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
	[alertView show];
	[alertView release];	
}

#pragma mark -
#pragma mark ObjectivePlurk delegate methods

- (void)plurk:(ObjectivePlurk *)plurk didUploadPicture:(NSDictionary *)result
{
	[self hideLoadingView];	
	NSString *full = [result valueForKey:@"full"];
	if (full) {
		NSString *text = [NSString stringWithFormat:@"%@ %@", full, self.title];
		pushingPlurkComposer = YES;
		[TWSocialComposer sharedComposer].mode = TWSocialComposerPlurkMode;
		[[TWSocialComposer sharedComposer] showWithText:text];
	}
}
- (void)plurk:(ObjectivePlurk *)plurk didFailUploadingPicture:(NSError *)error
{
	[self hideLoadingView];	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unable to upload image to Plurk.", @"") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

@synthesize imageView = _imageView;
@synthesize imageURL = _imageURL;	
@dynamic image;

@end
