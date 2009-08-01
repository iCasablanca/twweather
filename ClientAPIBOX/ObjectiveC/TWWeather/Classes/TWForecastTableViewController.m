//
//  TWForecastTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import "TWForecastTableViewController.h"
#import "TWForecastResultTableViewController.h"

@implementation TWForecastTableViewController

#pragma mark UIViewContoller Methods

- (void)viewDidLoad 
{
	[super viewDidLoad];
	self.array = [[TWAPIBox sharedBox] forecastLocations];
	self.title = @"48 小時天氣預報";
}

#pragma mark UITableViewDataSource and UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSMutableDictionary *dictionary = [[self array] objectAtIndex:indexPath.row];
	self.tableView.userInteractionEnabled = NO;
	[dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isLoading"];
	[self.tableView reloadData];

	NSString *identifier = [dictionary objectForKey:@"identifier"];
	[[TWAPIBox sharedBox] fetchForecastWithLocationIdentifier:identifier delegate:self userInfo:dictionary];
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchForecast:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	[self resetLoading];
//	NSLog(@"result:%@", [result description]);
	if ([result isKindOfClass:[NSDictionary class]]) {
		NSDictionary *dictionary = (NSDictionary *)result;
		TWForecastResultTableViewController *controller = [[TWForecastResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		controller.title = [dictionary objectForKey:@"locationName"];
		controller.forecastArray = [dictionary objectForKey:@"items"];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
	self.tableView.userInteractionEnabled = YES;
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchForecastWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	[self resetLoading];
	self.tableView.userInteractionEnabled = YES;
	[self pushErrorViewWithError:error];
}


@end

