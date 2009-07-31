//
//  TWTideTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWTideTableViewController.h"
#import "TWTideResultTableViewController.h"

@implementation TWTideTableViewController

- (void)viewDidLoad 
{
	[super viewDidLoad];
	self.array = [[TWAPIBox sharedBox] tideLocations];
	self.title = @"三天潮汐預報";
}

#pragma mark UITableViewDataSource and UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSMutableDictionary *dictionray = [[self array] objectAtIndex:indexPath.row];
	NSString *identifier = [dictionray objectForKey:@"identifier"];
	[[TWAPIBox sharedBox] fetchTideWithLocationIdentifier:identifier delegate:self userInfo:dictionray];
	self.tableView.userInteractionEnabled = NO;
	[dictionray setObject:[NSNumber numberWithBool:YES] forKey:@"isLoading"];
	[self.tableView reloadData];
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchTide:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	[self resetLoading];
	NSLog(@"result:%@", [result description]);
	if ([result isKindOfClass:[NSDictionary class]]) {
		TWTideResultTableViewController *controller = [[TWTideResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		controller.title = [result objectForKey:@"locationName"];
		controller.forecastArray = [result objectForKey:@"items"];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
	self.tableView.userInteractionEnabled = YES;
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchTideWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	[self resetLoading];
	self.tableView.userInteractionEnabled = YES;
}



@end

