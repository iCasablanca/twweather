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
	[self viewDidUnload];
	[_filteredArray release];
	[_filterArray release];
	[_favArray release];
    [super dealloc];
}

- (void)viewDidUnload
{
	[loadingView release];	
	loadingView = nil;
	[errorLabel release];
	errorLabel = nil;
	self.tableView = nil;
	self.view = nil;
	[super viewDidLoad];
}

#pragma mark UIViewContoller Methods

- (void)loadView 
{
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	view.backgroundColor = [UIColor colorWithHue:1.0 saturation:0.0 brightness:0.9 alpha:1.0];
	self.view = view;
	
	errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 200)];
	errorLabel.textAlignment = UITextAlignmentCenter;
	errorLabel.numberOfLines = 10;
	errorLabel.font = [UIFont boldSystemFontOfSize:18.0];
	errorLabel.backgroundColor = [UIColor colorWithHue:1.0 saturation:0.0 brightness:0.9 alpha:1.0];
	errorLabel.shadowColor = [UIColor whiteColor];
	errorLabel.shadowOffset = CGSizeMake(0, 2);
	[self.view addSubview:errorLabel];
	
	UITableView *aTableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped] autorelease];
	aTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	aTableView.delegate = self;
	aTableView.dataSource = self;
	self.tableView = aTableView;
	[self.view addSubview:self.tableView];
	
	loadingView = [[TWLoadingView alloc] initWithFrame:CGRectMake(100, 100, 120, 120)];	
}

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
		
	[self loadData];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(changeSetting:)];
	self.tabBarController.navigationItem.rightBarButtonItem = item;
	[item release];
	
	UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];
	self.tabBarController.navigationItem.leftBarButtonItem = reloadItem;
	[reloadItem release];	
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	self.tabBarController.navigationItem.rightBarButtonItem = nil;
	self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark -

- (IBAction)changeSetting:(id)sender
{
	self.tabBarController.selectedIndex = 0;	
	TWLocationSettingTableViewController *controller = [[TWLocationSettingTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.delegate = self;
	[controller setFilter:_filterArray];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	[controller release];
	[self.tabBarController presentModalViewController:navController animated:YES];
	[navController release];
}
- (IBAction)reload:(id)sender
{
	if (isLoading) {
		return;
	}
	self.tabBarController.selectedIndex = 0;
	[self loadData];
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
- (void)loadData
{
	[self showLoadingView];
	[[TWAPIBox sharedBox] fetchAllForecastsWithDelegate:self userInfo:nil];
}
- (void)showLoadingView
{
	[self.view addSubview:loadingView];
	[loadingView startAnimating];
	isLoading = YES;
	self.tableView.userInteractionEnabled = NO;
}
- (void)hideLoadingView
{
	[loadingView removeFromSuperview];
	[loadingView stopAnimating];
	isLoading = NO;
	self.tableView.userInteractionEnabled = YES;
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
	NSDictionary *item = [_filteredArray objectAtIndex:indexPath.section];
	NSDictionary *dictionary = [[item objectForKey:@"items"] objectAtIndex:0];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
	controller.weekLocation = [dictionary objectForKey:@"weekLocation"];
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

- (void)APIBox:(TWAPIBox *)APIBox didFetchAllForecasts:(id)result userInfo:(id)userInfo
{
	[self hideLoadingView];
	if ([result isKindOfClass:[NSArray class]]) {
		self.tableView.hidden = NO;
		NSArray *array = (NSArray *)result;
		[_favArray setArray:array];
		[self updateFilteredArray];
		[[NSUserDefaults standardUserDefaults] setObject:_favArray forKey:lastAllForecastsPreferenceName];
	}
	else if (![_favArray count]) {
		self.tableView.hidden = YES;
		errorLabel.text = NSLocalizedString(@"Failed to load data!", @"");
	}
	[self.tableView reloadData];
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchAllForecastsWithError:(NSError *)error
{
	[self hideLoadingView];
	self.tableView.hidden = YES;
	errorLabel.text = [error localizedDescription];
}

- (void)settingController:(TWLocationSettingTableViewController *)controller didUpdateFilter:(NSArray *)filterArray
{
	[_filterArray setArray:filterArray];
	[[NSUserDefaults standardUserDefaults] setObject:_filterArray forKey:favoitesPreferenceName];
	if (_favArray) {
		[self updateFilteredArray];
		[self.tableView reloadData];
	}
	else if (!isLoading) {
		[[TWAPIBox sharedBox] fetchAllForecastsWithDelegate:self userInfo:nil];
	}
}

@synthesize tableView = _tableView;

@end

