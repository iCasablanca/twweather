//
//  TWTideCell.h
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import <UIKit/UIKit.h>

@class TWTideCellContentView;

@interface TWTideCell : UITableViewCell 
{
	TWTideCellContentView *_ourContentView;
	NSString *dateString;
	NSString *lunarDateString;
	NSString *lowShortTime;
	NSString *lowHeight;
	NSString *highshortTime;
	NSString *highHeight;
}

@property (retain, nonatomic) NSString *dateString;
@property (retain, nonatomic) NSString *lunarDateString;
@property (retain, nonatomic) NSString *lowShortTime;
@property (retain, nonatomic) NSString *lowHeight;
@property (retain, nonatomic) NSString *highshortTime;
@property (retain, nonatomic) NSString *highHeight;

@end
