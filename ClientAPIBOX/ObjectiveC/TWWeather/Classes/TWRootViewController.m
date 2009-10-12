//
//  TWRootViewController.m
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import "TWRootViewController.h"
#import "TWLoadingCell.h"
#import "TWAPIBox.h"
#import "TWErrorViewController.h"
#import "TWOBSTableViewController.h"
#import "TWOverviewViewController.h"
#import "TWForecastTableViewController.h"
#import "TWForecastResultTableViewController.h"
#import "TWWeekTableViewController.h"
#import "TWWeekTravelTableViewController.h"
#import "TWThreeDaySeaTableViewController.h"
#import "TWNearSeaTableViewController.h"
#import "TWTideTableViewController.h"
#import "TWImageTableViewController.h"
#import "TWWeatherAppDelegate.h"

@implementation TWRootViewController

- (void)dealloc
{
	[super dealloc];
}
- (void)viewDidUnload
{
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
	[super viewDidLoad];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Forecasts", @"");
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return 9;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";    
	TWLoadingCell *cell = (TWLoadingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[TWLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
	cell.imageView.image = nil;
	if (indexPath.row != 0) {
		[cell stopAnimating];
	}		
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"目前天氣";
			break;				
		case 1:
			cell.textLabel.text = @"關心天氣";
			if (isLoadingOverview) {
				[cell startAnimating];
			}
			else {
				[cell stopAnimating];
			}
			break;				
		case 2:
			cell.textLabel.text = @"今明預報";
			break;
		case 3:
			cell.textLabel.text = @"一週天氣";
			break;				
		case 4:
			cell.textLabel.text = @"一週旅遊";
			break;				
		case 5:
			cell.textLabel.text = @"三天漁業";
			break;				
		case 6:
			cell.textLabel.text = @"台灣近海";
			break;				
		case 7:
			cell.textLabel.text = @"三天潮汐";
			break;				
		case 8:
			cell.textLabel.text = @"天氣觀測雲圖";
			break;				
		default:
			break;
	}
	return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewController *controller = nil;
	if (indexPath.row == 0) {
		controller = [[TWOBSTableViewController alloc] initWithStyle:UITableViewStylePlain];
	}		
	else if (indexPath.row == 1) {
		[[TWAPIBox sharedBox] fetchOverviewWithFormat:TWOverviewPlainFormat delegate:self userInfo:nil];
		isLoadingOverview = YES;
		[self.tableView reloadData];
		self.tableView.userInteractionEnabled = NO;
	}
	else if (indexPath.row == 2) {
		controller = [[TWForecastTableViewController alloc] initWithStyle:UITableViewStylePlain];
	}
	else if (indexPath.row == 3) {
		controller = [[TWWeekTableViewController alloc] initWithStyle:UITableViewStylePlain];
	}
	else if (indexPath.row == 4) {
		controller = [[TWWeekTravelTableViewController alloc] initWithStyle:UITableViewStylePlain];
	}
	else if (indexPath.row == 5) {
		controller = [[TWThreeDaySeaTableViewController alloc] initWithStyle:UITableViewStylePlain];
	}
	else if (indexPath.row == 6) {
		controller = [[TWNearSeaTableViewController alloc] initWithStyle:UITableViewStylePlain];
	}
	else if (indexPath.row == 7) {
		controller = [[TWTideTableViewController alloc] initWithStyle:UITableViewStylePlain];
	}
	else if (indexPath.row == 8) {
		controller = [[TWImageTableViewController alloc] initWithStyle:UITableViewStylePlain];
	}
	if (controller) {
		[[TWWeatherAppDelegate sharedDelegate] pushViewController:controller animated:YES];
		[controller release];
	}
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 45.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//	if (section == 0) {
//		return @"功能列表";
//	}
	return nil;
}

#pragma mark -

- (void)APIBox:(TWAPIBox *)APIBox didFetchOverview:(NSString *)string userInfo:(id)userInfo
{
	isLoadingOverview = NO;
	[self.tableView reloadData];
	self.tableView.userInteractionEnabled = YES;
	TWOverviewViewController *controller = [[TWOverviewViewController alloc] init];
	[[TWWeatherAppDelegate sharedDelegate] pushViewController:controller animated:YES];
	[controller setText:string];
	[controller release];
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchOverviewWithError:(NSError *)error
{
	isLoadingOverview = NO;
	[self.tableView reloadData];
	self.tableView.userInteractionEnabled = YES;
	TWErrorViewController *controller = [[TWErrorViewController alloc] init];
	controller.error = error;
	[[TWWeatherAppDelegate sharedDelegate] pushViewController:controller animated:YES];
	[controller release];
}

@end

