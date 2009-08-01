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

- (IBAction)changeCurrentLocationAction:(id)sender;

- (void)didFetchForecastOfCurrentLocation:(NSNotification *)notification;

@end
