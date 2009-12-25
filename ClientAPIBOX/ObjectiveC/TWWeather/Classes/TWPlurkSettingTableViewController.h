//
//  TWPlurkSettingTableViewController.h
//  TWWeather
//
//  Created by zonble on 12/26/09.
//  Copyright 2009 Lithoglyph Inc.. All rights reserved.
//

#import "ObjectivePlurk.h"

@interface TWPlurkSettingTableViewController : UITableViewController <UITextFieldDelegate>
{
	UITextField *loginNameField;
	UITextField *passwordField;
	UIButton *loginButton;
}

- (void)refresh;
- (IBAction)loginAciton:(id)sender;
- (IBAction)logoutAction:(id)sender;

@end
