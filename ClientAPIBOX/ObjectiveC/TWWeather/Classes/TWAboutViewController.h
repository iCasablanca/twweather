//
//  TWAboutViewController.h
//  TWWeather
//
//  Created by zonble on 2009/08/02.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface TWAboutViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
	UILabel *titleLabel;
	UILabel *copyrightLabel;
	UILabel *externalLibraryLabel;
}

- (void)sendEmailAction:(id)sender;

@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UILabel *copyrightLabel;
@property (retain, nonatomic) UILabel *externalLibraryLabel;

@end
