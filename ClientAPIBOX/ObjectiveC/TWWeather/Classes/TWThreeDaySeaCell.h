//
//  TWThreeDaySeaCell.h
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import <UIKit/UIKit.h>

@class TWThreeDaySeaCellContentView;

@interface TWThreeDaySeaCell : UITableViewCell 
{
	TWThreeDaySeaCellContentView *_ourContentView;
	NSString *date;
	NSString *description;
	NSString *wind;
	NSString *windLevel;
	NSString *wave;
	UIImage *weatherImage;
}

@property (retain, nonatomic) NSString *date;
@property (retain, nonatomic) NSString *description;
@property (retain, nonatomic) NSString *wind;
@property (retain, nonatomic) NSString *windLevel;
@property (retain, nonatomic) NSString *wave;
@property (retain, nonatomic) UIImage *weatherImage;

@end
