//
//  ZBForecastPickerViewController.h
//  TWWeather
//
//  Created by zonble on 2009/1/14.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBForecastsArrayController.h"

@interface ZBForecastPickerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UIToolbar *_toolbar;
	IBOutlet UITableView *_tableView;
	ZBForecastsArrayController *_arrayController;
}

- (IBAction)closeAction:(id)sender;

@end
