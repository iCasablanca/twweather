//
//  RootViewController.m
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import "RootViewController.h"
#import "TWLoadingCell.h"
#import "TWAPIBox.h"
#import "TWErrorViewController.h"
#import "TWOverviewViewController.h"
#import "TWForecastTableViewController.h"
#import "TWWeekTableViewController.h"
#import "TWWeekTravelTableViewController.h"
#import "TWThreeDaySeaTableViewController.h"
#import "TWNearSeaTableViewController.h"
#import "TWTideTableViewController.h"
#import "TWImageTableViewController.h"
#import "TWLocationSettingTableViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWForecastResultCell.h"

@implementation RootViewController

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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
	self.title = @"台灣天氣";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFetchForecastOfCurrentLocation:) name:TWCurrentForecastDidFetchNotification object:nil];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"區域設定" style:UIBarButtonItemStyleBordered target:self action:@selector(changeCurrentLocationAction:)];
	self.navigationItem.rightBarButtonItem = item;
	[item release];
}
//- (void)viewWillAppear:(BOOL)animated 
//{
//    [super viewWillAppear:animated];
//}
//- (void)viewDidAppear:(BOOL)animated 
//{
//    [super viewDidAppear:animated];
//}
//- (void)viewWillDisappear:(BOOL)animated 
//{
//	[super viewWillDisappear:animated];
//}
//- (void)viewDidDisappear:(BOOL)animated 
//{
//	[super viewDidDisappear:animated];
//}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark -

- (IBAction)changeCurrentLocationAction:(id)sender
{
	if (isLoadingOverview) {
		return;
	}
	
	TWLocationSettingTableViewController *controller = [[TWLocationSettingTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	[controller release];
	[self presentModalViewController:navController animated:YES];
	[navController release];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (section == 0) {
		if ([TWWeatherAppDelegate sharedDelegate].forecastOfCurrentLocation) {
			return 1;
		}
		return 0;
	}
	else if (section == 1) {
		return 8;
	}
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *ForecastIdentifier = @"ForecastCell";
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.section == 0) {
		TWForecastResultCell *cell = (TWForecastResultCell *)[tableView dequeueReusableCellWithIdentifier:ForecastIdentifier];
		if (cell == nil) {
			cell = [[[TWForecastResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ForecastIdentifier] autorelease];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		NSDictionary *dictionary = [[[TWWeatherAppDelegate sharedDelegate].forecastOfCurrentLocation objectForKey:@"items"] objectAtIndex:0];
		cell.title = [dictionary objectForKey:@"title"];
		cell.description = [dictionary objectForKey:@"description"];
		cell.rain = [dictionary objectForKey:@"rain"];
		cell.temperature = [dictionary objectForKey:@"temperature"];
		NSString *beginTimeString = [dictionary objectForKey:@"beginTime"];
		NSDate *beginDate = [[TWAPIBox sharedBox] dateFromString:beginTimeString];
		cell.beginTime = [[TWAPIBox sharedBox] shortDateTimeStringFromDate:beginDate];
		NSString *endTimeString = [dictionary objectForKey:@"endTime"];
		NSDate *endDate = [[TWAPIBox sharedBox] dateFromString:endTimeString];
		cell.endTime = [[TWAPIBox sharedBox] shortDateTimeStringFromDate:endDate];
		
		NSString *imageString = [[TWWeatherAppDelegate sharedDelegate] imageNameWithTimeTitle:cell.title description:cell.description ];
		cell.weatherImage = [UIImage imageNamed:imageString];
		
		[cell setNeedsDisplay];		
		return cell;
	}
	else if (indexPath.section == 1) {
		TWLoadingCell *cell = (TWLoadingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[TWLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		if (indexPath.row != 0) {
			[cell stopAnimating];
		}		
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"關心天氣";
				if (isLoadingOverview) {
					[cell startAnimating];
				}
				else {
					[cell stopAnimating];
				}
				break;				
			case 1:
				cell.textLabel.text = @"今明預報";
				break;
			case 2:
				cell.textLabel.text = @"一週天氣";
				break;				
			case 3:
				cell.textLabel.text = @"一週旅遊";
				break;				
			case 4:
				cell.textLabel.text = @"三天漁業";
				break;				
			case 5:
				cell.textLabel.text = @"台灣近海";
				break;				
			case 6:
				cell.textLabel.text = @"三天潮汐";
				break;				
			case 7:
				cell.textLabel.text = @"天氣觀測雲圖";
				break;				
			default:
				break;
		}
		return cell;
	}
	return nil;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.section == 0) {
	}
	else if (indexPath.section == 1) {
		UITableViewController *controller = nil;
		if (indexPath.row == 0) {
			[[TWAPIBox sharedBox] fetchOverviewWithFormat:TWOverviewPlainFormat delegate:self userInfo:nil];
			isLoadingOverview = YES;
			[self.tableView reloadData];
			self.tableView.userInteractionEnabled = NO;
		}
		else if (indexPath.row == 1) {
			controller = [[TWForecastTableViewController alloc] initWithStyle:UITableViewStylePlain];
		}
		else if (indexPath.row == 2) {
			controller = [[TWWeekTableViewController alloc] initWithStyle:UITableViewStylePlain];
		}
		else if (indexPath.row == 3) {
			controller = [[TWWeekTravelTableViewController alloc] initWithStyle:UITableViewStylePlain];
		}
		else if (indexPath.row == 4) {
			controller = [[TWThreeDaySeaTableViewController alloc] initWithStyle:UITableViewStylePlain];
		}
		else if (indexPath.row == 5) {
			controller = [[TWNearSeaTableViewController alloc] initWithStyle:UITableViewStylePlain];
		}
		else if (indexPath.row == 6) {
			controller = [[TWTideTableViewController alloc] initWithStyle:UITableViewStylePlain];
		}
		else if (indexPath.row == 7) {
			controller = [[TWImageTableViewController alloc] initWithStyle:UITableViewStylePlain];
		}
		if (controller) {
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
	}
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return 130.0;
	}
	else if (indexPath.section == 1) {
		return 45.0;
	}
	return 0.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		NSDictionary *dictionary = [TWWeatherAppDelegate sharedDelegate].forecastOfCurrentLocation;
		if (dictionary) {
			NSString *location = [dictionary objectForKey:@"locationName"];
			if (location) {
				return [location stringByAppendingString:@"目前天氣"];
			}			
		}
	}
	else if (section == 1) {
		return @"功能列表";
	}
	return nil;
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchOverview:(NSString *)string userInfo:(id)userInfo
{
	isLoadingOverview = NO;
	[self.tableView reloadData];
	self.tableView.userInteractionEnabled = YES;
	TWOverviewViewController *controller = [[TWOverviewViewController alloc] init];
	[controller setText:string];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchOverviewWithError:(NSError *)error
{
	isLoadingOverview = NO;
	[self.tableView reloadData];
	self.tableView.userInteractionEnabled = YES;
	TWErrorViewController *controller = [[TWErrorViewController alloc] init];
	controller.error = error;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)didFetchForecastOfCurrentLocation:(NSNotification *)notification
{
	[self.tableView reloadData];
}

@end

