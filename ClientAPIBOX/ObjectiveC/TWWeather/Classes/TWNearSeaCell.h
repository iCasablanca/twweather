//
//  TWNearSeaCell.h
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import <UIKit/UIKit.h>

@class TWNearSeaCellContentView;

@interface TWNearSeaCell : UITableViewCell 
{
	TWNearSeaCellContentView *_ourContentView;
	NSString *description;
	NSString *validBeginTime;
    NSString *validEndTime;
    NSString *wave;
    NSString *waveLevel;
    NSString *wind;
    NSString *windScale;
}

@property (retain, nonatomic) NSString *description;
@property (retain, nonatomic) NSString *validBeginTime;
@property (retain, nonatomic) NSString *validEndTime;
@property (retain, nonatomic) NSString *wave;
@property (retain, nonatomic) NSString *waveLevel;
@property (retain, nonatomic) NSString *wind;
@property (retain, nonatomic) NSString *windScale;


@end
