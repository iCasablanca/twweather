//
//  TWNearSeaResultViewController.h
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import <UIKit/UIKit.h>


@interface TWNearSeaResultTableViewController : UITableViewController 
{
	NSString *description;;
	NSString *publishTime;
	NSString *validBeginTime;
    NSString *validEndTime;
    NSString *wave;
    NSString *waveLevel;
    NSString *wind;
    NSString *windLevel;
}

@property (retain, nonatomic) NSString *description;
@property (retain, nonatomic) NSString *publishTime;
@property (retain, nonatomic) NSString *validBeginTime;
@property (retain, nonatomic) NSString *validEndTime;
@property (retain, nonatomic) NSString *wave;
@property (retain, nonatomic) NSString *waveLevel;
@property (retain, nonatomic) NSString *wind;
@property (retain, nonatomic) NSString *windLevel;

@end
