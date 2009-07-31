//
//  TWWeekResultCell.h
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import <UIKit/UIKit.h>

@class TWWeekResultCellContentView;

@interface TWWeekResultCell : UITableViewCell 
{
	TWWeekResultCellContentView *_ourContentView;
	NSString *date;
	NSString *description;
	NSString *temperature;
}

@property (retain, nonatomic) NSString *date;
@property (retain, nonatomic) NSString *description;
@property (retain, nonatomic) NSString *temperature;

@end
