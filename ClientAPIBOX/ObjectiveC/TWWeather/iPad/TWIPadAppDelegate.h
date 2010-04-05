//
//  TWIPadAppDelegate.h
//  TWWeather
//
//  Created by zonble on 4/5/10.
//  Copyright 2010 Lithoglyph Inc. All rights reserved.
//

@class TWIPadSourceListTableVoewController;
@class TWIPadMainViewController;

@interface TWIPadAppDelegate : NSObject 
{
	UIWindow *window;
	UIViewController *splitViewController;
	TWIPadSourceListTableVoewController *sourceListTableViewController;
	TWIPadMainViewController *mainViewController;
}

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) UIViewController *splitViewController;
@property (retain, nonatomic) TWIPadSourceListTableVoewController *sourceListTableViewController;
@property (retain, nonatomic) TWIPadMainViewController *mainViewController;

@end
