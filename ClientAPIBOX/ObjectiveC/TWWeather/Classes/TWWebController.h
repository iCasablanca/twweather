//
//  TWWebController.h
//  TWWeather
//
//  Created by zonble on 10/11/09.
//  Copyright 2009 Lithoglyph Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TWWebController : UIViewController <UIWebViewDelegate>
{
	UIWebView *webView;
}

@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end
