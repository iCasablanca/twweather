//
//  RootViewController.h
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

@interface RootViewController : UITableViewController 
{
	BOOL isLoadingOverview;
}

- (void)didFetchForecastOfCurrentLocation:(NSNotification *)notification;

@end
