//
//  TWFavoriteTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/07.
//

#import "TWFavoriteTableViewController.h"
#import "TWForecastResultTableViewController.h"
#import "TWForecastResultCell.h"
#import "TWWeatherAppDelegate.h"
#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"

static NSString *lastAllForecastsPreferenceName = @"lastAllForecastsPreferenceName";
static NSString *favoitesPreferenceName = @"favoitesPreferenceName";

@implementation TWFavoriteTableViewController

- (void)dealloc 
{
	[_filteredArray release];
	[_filterArray release];
	[_favArray release];
    [super dealloc];
}

#pragma mark UIViewContoller Methods

- (void)viewDidLoad 
{
	[super viewDidLoad];
	if (!_favArray) {
		_favArray = [[NSMutableArray alloc] init];
		NSArray *savedResult = [[NSUserDefaults standardUserDefaults] objectForKey:lastAllForecastsPreferenceName];
		if (savedResult) {
			[_favArray setArray:savedResult];
		}
	}
	if (!_filterArray) {
		_filterArray = [[NSMutableArray alloc] init];
		
		NSArray *favoitesSetting = [[NSUserDefaults standardUserDefaults] objectForKey:favoitesPreferenceName];
		if (!favoitesSetting) {
			favoitesSetting = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
			[[NSUserDefaults standardUserDefaults] setObject:favoitesSetting forKey:favoitesPreferenceName];
		}
		[_filterArray setArray:favoitesSetting];
	}
	if (!_filteredArray) {
		_filteredArray = [[NSMutableArray alloc] init];
		[self updateFilteredArray];
	}
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(changeSetting:)];
	self.tabBarController.navigationItem.rightBarButtonItem = item;
	[item release];
	
	[[TWAPIBox sharedBox] fetchAllForecastsWithDelegate:self userInfo:nil];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (![_filteredArray count]) {
		return 1;
	}
	return [_filteredArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([_filteredArray count]) {
		return 1;
	}
	return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    TWForecastResultCell *cell = (TWForecastResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TWForecastResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
//	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	NSDictionary *item = [_filteredArray objectAtIndex:indexPath.section];
	NSDictionary *dictionary = [[item objectForKey:@"items"] objectAtIndex:0];
	
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *dictionary = [_filteredArray objectAtIndex:indexPath.section];
	TWForecastResultTableViewController *controller = [[TWForecastResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.title = [dictionary objectForKey:@"locationName"];
	controller.forecastArray = [dictionary objectForKey:@"items"];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ([_filteredArray count])  {
		NSDictionary *item = [_filteredArray objectAtIndex:section];
		return [item objectForKey:@"locationName"];
	}		
	return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 130.0;
}

#pragma mark -

- (IBAction)changeSetting:(id)sender
{
	TWLocationSettingTableViewController *controller = [[TWLocationSettingTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.delegate = self;
	[controller setFilter:_filterArray];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	[controller release];
	[self.tabBarController presentModalViewController:navController animated:YES];
	[navController release];
}

- (void)updateFilteredArray
{
	[_filteredArray removeAllObjects];
	for (NSInteger i = 0; i < [_favArray count]; i++) {
		NSNumber *number = [NSNumber numberWithInt:i];
		if ([_filterArray containsObject:number]) {
			NSDictionary *dictionary = [_favArray objectAtIndex:i];
			[_filteredArray addObject:dictionary];
		}
	}
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchAllForecasts:(id)result userInfo:(id)userInfo
{
//	NSLog(@"result:%@", [result description]);
//	NSLog(@"has result");
	if ([result isKindOfClass:[NSArray class]]) {
		NSArray *arrary = (NSArray *)result;
		[_favArray setArray:arrary];
		[self updateFilteredArray];
		[[NSUserDefaults standardUserDefaults] setObject:_favArray forKey:lastAllForecastsPreferenceName];
	}
	[self.tableView reloadData];
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchAllForecastsWithError:(NSError *)error
{
}

- (void)settingController:(TWLocationSettingTableViewController *)controller didUpdateFilter:(NSArray *)filterArray
{
	[_filterArray setArray:filterArray];
	[[NSUserDefaults standardUserDefaults] setObject:_filterArray forKey:favoitesPreferenceName];
	if (_favArray) {
		[self updateFilteredArray];
		[self.tableView reloadData];
	}
	else {
		[[TWAPIBox sharedBox] fetchAllForecastsWithDelegate:self userInfo:nil];
	}
}

@end

