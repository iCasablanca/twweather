//
//  TWBasicForecastTableViewController.h
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import <UIKit/UIKit.h>
#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"

@interface TWBasicForecastTableViewController : UITableViewController 
{
	NSMutableArray *_array;
}

- (void)resetLoading;

@property (assign, nonatomic) NSArray *array;

@end
