//
//  ZBWeekTableViewCell.h
//  TWWeather
//
//  Created by zonble on 2009/1/18.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBWeekTableViewCell;

@interface ZBWeekTableViewCellContentView : UIView {
	ZBWeekTableViewCell *_delegate;
}

@property (readwrite, assign, nonatomic) id delegate;
@end

@interface ZBWeekTableViewCell : UITableViewCell {
	NSString *_date;
	NSString *_temperature;
	NSString *_description;	
	ZBWeekTableViewCellContentView *_forecastContentView;	
	UIImage *_forecastImage;
}

- (void)setImageByCondition;

@property (readwrite, retain, nonatomic) NSString *date;
@property (readwrite, retain, nonatomic) NSString *temperature;
@property (readwrite, retain, nonatomic) NSString *description;
@property (readwrite, retain, nonatomic) UIImage *forecastImage;

@end
