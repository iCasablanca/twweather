//
//  TWOverviewViewController.h
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//  Copyright 2009 Lithoglyph Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TWOverviewViewController : UIViewController 
{
	UITextView *textView;
	NSString *_text;
}

- (void)setText:(NSString *)text;
- (IBAction)copy:(id)sender;

@property (retain, nonatomic) UITextView *textView;
@property (retain, nonatomic) NSString *text;

@end
