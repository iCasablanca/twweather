//
//  TWForecastResultCell.h
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import <UIKit/UIKit.h>

@class TWForecastResultCellContentView;

@interface TWForecastResultCell : UITableViewCell 
{
	TWForecastResultCellContentView *_ourContentView;
	NSString *title;
	NSString *description;
	NSString *rain;
	NSString *temperature;
	NSString *beginTime;
	NSString *endTime;
}

@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *description;
@property (retain, nonatomic) NSString *rain;
@property (retain, nonatomic) NSString *temperature;
@property (retain, nonatomic) NSString *beginTime;
@property (retain, nonatomic) NSString *endTime;

@end
