//
//  TWPlurkComposer.h
//  TWWeather
//
//  Created by zonble on 12/26/09.
//

#import "ObjectivePlurk.h"

@interface TWPlurkComposerViewController : UIViewController
{
	UITextView *textView;
}

- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;

@property (readonly) UITextView *textView;

@end

@interface TWPlurkComposer : UINavigationController
{
}

+ (TWPlurkComposer *)sharedComposer;
- (void)showWithController:(UIViewController *)controller text:(NSString *)text;

@end
