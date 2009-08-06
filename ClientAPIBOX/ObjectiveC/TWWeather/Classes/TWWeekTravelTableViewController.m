//
//  TWWeekTravelTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWWeekTravelTableViewController.h"
#import "TWWeekResultTableViewController.h"

@implementation TWWeekTravelTableViewController

#pragma mark UIViewContoller Methods

- (void)viewDidLoad 
{
	[super viewDidLoad];
	self.array = [[TWAPIBox sharedBox] weekTravelLocations];
	self.title = @"一週旅遊天氣預報";
}
- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated 
{
	[super viewDidDisappear:animated];
}

#pragma mark UITableViewDataSource and UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSMutableDictionary *dictionary = [[self arrayForTableView:tableView] objectAtIndex:indexPath.row];
	tableView.userInteractionEnabled = NO;
	[dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isLoading"];
	[tableView reloadData];

	NSString *identifier = [dictionary objectForKey:@"identifier"];
	[[TWAPIBox sharedBox] fetchWeekTravelWithLocationIdentifier:identifier delegate:self userInfo:dictionary];
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchWeekTravel:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	[self resetLoading];
	if ([result isKindOfClass:[NSDictionary class]]) {
		TWWeekResultTableViewController *controller = [[TWWeekResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		controller.title = [result objectForKey:@"locationName"];
		controller.forecastArray = [result objectForKey:@"items"];
		NSString *dateString = [result objectForKey:@"publishTime"];
		NSDate *date = [[TWAPIBox sharedBox] dateFromShortString:dateString];
		controller.publishTime = [[TWAPIBox sharedBox] shortDateTimeStringFromDate:date];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWeekTravelWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	[self resetLoading];
	[self pushErrorViewWithError:error];
}


@end

