//
//  TWWebController.m
//  TWWeather
//
//  Created by zonble on 10/11/09.
//  Copyright 2009 zonble.net. All rights reserved.
//

#import "TWWebController.h"


@implementation TWWebController

- (void)removeOutletsAndControls_TWWebController
{
    // remove and clean outlets and controls here
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// The designated initializer.  Override if you create the controller
// programmatically and want to perform customization that is not appropriate 
// for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

#pragma mark -
#pragma mark UIViewContoller Methods

/*
// Implement loadView to create a view hierarchy programmatically, without
// using a nib.
- (void)loadView 
{
}
*/
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
- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated 
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		[self openInExternalWebBrowser];
	}
}

#pragma mark -

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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
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
