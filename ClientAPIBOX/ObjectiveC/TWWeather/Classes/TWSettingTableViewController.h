//
//  TWSettingTableViewController.h
//  TWWeather
//
//  Created by zonble on 10/13/09.
//

#import "FBConnect/FBConnect.h"

@interface TWSettingTableViewController : UITableViewController
{
	UISwitch *BGMSwitch;
	FBLoginButton *loginButton;	
}

- (IBAction)toggleBGMSettingAction:(id)sender;

@end
