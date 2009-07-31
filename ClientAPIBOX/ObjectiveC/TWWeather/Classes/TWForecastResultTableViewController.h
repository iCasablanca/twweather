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
}

@property (retain, nonatomic) NSArray *forecastArray;

@end
