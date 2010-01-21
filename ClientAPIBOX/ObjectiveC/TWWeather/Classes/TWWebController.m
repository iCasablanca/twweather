//
// TWWebController.m
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

#import "TWWebController.h"

@implementation TWWebController

#pragma mark Routines

- (void)removeOutletsAndControls_TWWebController
{
	[self.webView stopLoading];
	self.webView = nil;
	self.activityIndicatorView = nil;
	self.toolbar = nil;
	self.goBackItem = nil;
	self.goFowardItem = nil;
	self.stopItem = nil;
	self.reloadItem = nil;
}

- (void)dealloc 
{
	[self removeOutletsAndControls_TWWebController];
    [super dealloc];
}
- (void)viewDidUnload
{
	[super viewDidUnload];
	[self removeOutletsAndControls_TWWebController];
}

#pragma mark -
#pragma mark UIViewContoller Methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
	self.navigationItem.rightBarButtonItem = item;
	[item release];
	activityIndicatorView.hidesWhenStopped = YES;
	[webView setDelegate:self];
	[self updateButtonState];
}

#pragma mark Actions

- (void)openInExternalWebBrowser
{
	NSURL *URL = [webView.request URL];
	[[UIApplication sharedApplication] openURL:URL];
}

- (IBAction)openInExternalWebBrowser:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open in Safari", @""), nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

#pragma mark -
#pragma mark UIActionSheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		[self openInExternalWebBrowser];
	}
}

#pragma mark -
#pragma mark WebView delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[activityIndicatorView startAnimating];
	[self updateButtonState];
	[reloadItem setEnabled:NO];
	[stopItem setEnabled:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[activityIndicatorView startAnimating];	
	[self updateButtonState];
	[reloadItem setEnabled:YES];
	[stopItem setEnabled:NO];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to open web page.", @"") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
	self.title = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
	
	[activityIndicatorView stopAnimating];
	[self updateButtonState];
	[reloadItem setEnabled:YES];
	[stopItem setEnabled:NO];
}

- (void)updateButtonState
{
	[goBackItem setEnabled:[webView canGoBack]];
	[goFowardItem setEnabled:[webView canGoForward]];
}

@synthesize webView;
@synthesize activityIndicatorView;
@synthesize toolbar;
@synthesize goBackItem;
@synthesize goFowardItem;
@synthesize stopItem;
@synthesize reloadItem;

@end
