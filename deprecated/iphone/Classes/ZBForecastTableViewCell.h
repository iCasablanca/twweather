//
//  ZBForcastTableViewCell.h
//  TWWeather
//
//  Created by zonble on 2009/1/13.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBForecastTableViewCell;

@interface ZBForcastTableViewCellContentView : UIView {
	ZBForecastTableViewCell *_delegate;
}

@property (readwrite, assign, nonatomic) id delegate;
@end

@interface ZBForecastTableViewCell : UITableViewCell {
	NSString *_timeTitle;
	NSString *_date;
	NSString *_temperature;
	NSString *_rain;
	NSString *_description;
	
	ZBForcastTableViewCellContentView *_forecastContentView;
	
	UIImage *_forecastImage;
	BOOL _lackingData;
}

- (void)setiImageByCondition;

@property (readwrite, retain, nonatomic) NSString *title;
@property (readwrite, retain, nonatomic) NSString *date;
@property (readwrite, retain, nonatomic) NSString *temperature;
@property (readwrite, retain, nonatomic) NSString *rain;
@property (readwrite, retain, nonatomic) NSString *description;
@property (readwrite, retain, nonatomic) UIImage *forecastImage;
@property (assign) BOOL lackingData;
@end
