//
//  TWOBSTableViewController.h
//  TWWeather
//
//  Created by zonble on 2009/08/07.
//

#import <UIKit/UIKit.h>
#import "TWBasicForecastTableViewController.h"
#import "TWAPIBox.h"

@interface TWOBSTableViewController : TWBasicForecastTableViewController 
{
	NSMutableArray *_locations;
}

@end
