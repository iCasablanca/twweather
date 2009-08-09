//
//  TWForecastResultTableViewController.h
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import <UIKit/UIKit.h>


@interface TWForecastResultTableViewController : UITableViewController 
{
	NSArray *forecastArray;
	NSString *weekLocation;
	NSDictionary *weekDictionary;
	
	BOOL isLoadingWeek;
}

- (void)pushWeekViewController;

@property (retain, nonatomic) NSArray *forecastArray;
@property (retain, nonatomic) NSString *weekLocation;
@property (retain, nonatomic) NSDictionary *weekDictionary;

@end
