//
//  ZBForecastTableViewController.h
//  TWWeather
//
//  Created by zonble on 2009/1/13.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWWeatherAPI.h"

@interface ZBForecastTableViewController : UITableViewController <ZBForecastParserDelegate>{
	NSString *_URLString;
	NSString *_name;
	NSArray *_forecasts;
}

- (void)parse;

@property (readwrite, retain, nonatomic) NSString *URLString;
@property (readwrite, retain, nonatomic) NSString *name;
@property (readwrite, retain, nonatomic) NSArray *forecasts;

@end
