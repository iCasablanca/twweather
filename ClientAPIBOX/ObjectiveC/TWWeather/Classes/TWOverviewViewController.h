//
//  TWOverviewViewController.h
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//  Copyright 2009 Lithoglyph Inc.. All rights reserved.
//

@interface TWOverviewViewController : UIViewController <UIActionSheetDelegate>
{
	UITextView *textView;
	NSString *_text;
}

- (void)setText:(NSString *)text;
- (void)copy;
- (void)shareViaFacebook;
- (IBAction)navBarAction:(id)sender;

@property (retain, nonatomic) UITextView *textView;
@property (retain, nonatomic) NSString *text;

@end
