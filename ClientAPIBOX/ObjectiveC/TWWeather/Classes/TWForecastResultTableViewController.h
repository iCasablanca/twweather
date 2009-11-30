//
//  TWForecastResultTableViewController.h
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import "FBConnect/FBConnect.h"

@interface TWForecastResultTableViewController : UITableViewController <UIActionSheetDelegate>
{
	NSArray *forecastArray;
	NSString *weekLocation;
	NSDictionary *weekDictionary;
	
	BOOL isLoadingWeek;
}

- (IBAction)navBarAction:(id)sender;
- (void)shareViaFacebook;
- (void)pushWeekViewController;

@property (retain, nonatomic) NSArray *forecastArray;
@property (retain, nonatomic) NSString *weekLocation;
@property (retain, nonatomic) NSDictionary *weekDictionary;

@end
