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
	
	NSArray *tides;
}

@property (retain, nonatomic) NSString *dateString;
@property (retain, nonatomic) NSString *lunarDateString;
@property (retain, nonatomic) NSArray *tides;

@end
