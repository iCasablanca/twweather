//
//  TWWebController.h
//  TWWeather
//
//  Created by zonble on 10/11/09.
//  Copyright 2009 zonble.net. All rights reserved.
//

@interface TWWebController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>
{
	UIWebView *webView;
	UIActivityIndicatorView *activityIndicatorView;
	UIBarButtonItem *goBackItem;
	UIBarButtonItem *goFowardItem;
	UIBarButtonItem *stopItem;
	UIBarButtonItem *reloadItem;
	UIToolbar *toolbar;
}

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (retain, nonatomic) IBOutlet UIToolbar *toolbar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *goFowardItem;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *stopItem;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *reloadItem;

- (void)openInExternalWebBrowser;
- (IBAction)openInExternalWebBrowser:(id)sender;
- (void)updateButtonState;

@end
