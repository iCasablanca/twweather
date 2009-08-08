//
//  TWOBSCell.h
//  TWWeather
//
//  Created by zonble on 2009/08/08.
//

#import <UIKit/UIKit.h>

@class TWOBSCellContentView;

@interface TWOBSCell : UITableViewCell 
{
	TWOBSCellContentView *_ourContentView;
	
	NSString *description;
	NSString *rain;
	NSString *temperature;
	NSString *windDirection;
	NSString *windLevel;
	NSString *windStrongestLevel;
	UIImage *weatherImage;
}

@property (retain, nonatomic) NSString *description;
@property (retain, nonatomic) NSString *rain;
@property (retain, nonatomic) NSString *temperature;
@property (retain, nonatomic) NSString *windDirection;
@property (retain, nonatomic) NSString *windLevel;
@property (retain, nonatomic) NSString *windStrongestLevel;
@property (retain, nonatomic) UIImage *weatherImage;;

@end
