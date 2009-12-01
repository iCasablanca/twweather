//
//  TWOBSCell.h
//  TWWeather
//
//  Created by zonble on 2009/08/08.
//

@class TWOBSCellContentView;

@interface TWOBSCell : UITableViewCell 
{
	TWOBSCellContentView *_ourContentView;
	
	NSString *description;
	NSString *rain;
	NSString *temperature;
	NSString *windDirection;
	NSString *windScale;
	NSString *gustWindScale;
	UIImage *weatherImage;
}

@property (retain, nonatomic) NSString *description;
@property (retain, nonatomic) NSString *rain;
@property (retain, nonatomic) NSString *temperature;
@property (retain, nonatomic) NSString *windDirection;
@property (retain, nonatomic) NSString *windScale;
@property (retain, nonatomic) NSString *gustWindScale;
@property (retain, nonatomic) UIImage *weatherImage;;

@end
