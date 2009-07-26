//
//  ZBWeekTableViewController.h
//  TWWeather
//
//  Created by zonble on 2009/1/17.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZBWeekTableViewController : UITableViewController {
	NSString *_name;
	NSString *_URLString;
	NSArray *_weekArray;
}

- (void)parse;

@property (readwrite, retain, nonatomic) NSString *name;
@property (readwrite, retain, nonatomic) NSString *URLString;
//@property (readwrite, retain, nonatomic) NSArray *weekArray;

@end
