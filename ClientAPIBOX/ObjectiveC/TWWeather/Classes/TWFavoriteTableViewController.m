//
//  TWFavoriteTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/07.
//

#import "TWFavoriteTableViewController.h"
#import "TWForecastResultTableViewController.h"
#import "TWOverviewViewController.h"
#import "TWWebController.h"
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
	if (!warningArray) {
		warningArray = [[NSMutableArray alloc] init];
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
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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
	navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
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
	[[TWAPIBox sharedBox] fetchWarningsWithDelegate:self userInfo:nil];	
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
	return [_filteredArray count] + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		NSUInteger count = [warningArray count];
		for (NSDictionary *dictionary in warningArray) {
			NSString *name = [dictionary objectForKey:@"name"];
			if ([name rangeOfString:@"颱風"].location != NSNotFound) {
				return count + 1;
			}
		}
		return count;
	}
	
	if ([_filteredArray count]) {
		return 1;
	}
	return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	static NSString *WarningCellIdentifier = @"WarningCellIdentifier";

	if (indexPath.section == 0) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WarningCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WarningCellIdentifier] autorelease];
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		if (indexPath.row >= [warningArray count]) {
			cell.textLabel.text = @"人事行政局網頁";
		}
		else {
			NSDictionary *dictionary = [warningArray objectAtIndex:indexPath.row];
			cell.textLabel.text = [dictionary objectForKey:@"name"];
		}
		return cell;
	}
	
    static NSString *CellIdentifier = @"Cell";
    
    TWForecastResultCell *cell = (TWForecastResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TWForecastResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	NSDictionary *item = [_filteredArray objectAtIndex:indexPath.section - 1];
	
	if ([item isKindOfClass:[NSDictionary class]]) {
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
	}
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
	if (indexPath.section == 0) {
		if (indexPath.row >= [warningArray count]) {
			TWWebController *webController = [[TWWebController alloc] initWithNibName:@"TWWebController" bundle:[NSBundle mainBundle]];
			webController.title = @"人事行政局網頁";
			[[TWWeatherAppDelegate sharedDelegate] pushViewController:webController animated:YES];
			[webController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.cpa.gov.tw/"]]];
			[webController release];
			return;			
		}		
		NSDictionary *dictionary = [warningArray objectAtIndex:indexPath.row];
		TWOverviewViewController *controller = [[TWOverviewViewController alloc] init];
		[controller setText:[dictionary objectForKey:@"text"]];
		controller.title = [dictionary objectForKey:@"name"];
		[[TWWeatherAppDelegate sharedDelegate] pushViewController:controller animated:YES];
		[controller release];
		return;
	}
	
	NSDictionary *dictionary = [_filteredArray objectAtIndex:indexPath.section - 1];
	TWForecastResultTableViewController *controller = [[TWForecastResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.title = [dictionary objectForKey:@"locationName"];
	controller.forecastArray = [dictionary objectForKey:@"items"];
	controller.weekLocation = [dictionary objectForKey:@"weekLocation"];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return nil;
	}
	
	if ([_filteredArray count])  {
		NSDictionary *item = [_filteredArray objectAtIndex:section - 1];
		return [item objectForKey:@"locationName"];
	}		
	return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return 40.0;
	}
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
	if (retryCount < 1) {
		[self loadData];
		retryCount++;
	}
	retryCount = 0;	
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

- (void)APIBox:(TWAPIBox *)APIBox didFetchWarnings:(id)result userInfo:(id)userInfo
{
	if ([result isKindOfClass:[NSArray class]]) {
		[warningArray setArray:result];
	}
	[self.tableView reloadData];
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWarningsWithError:(NSError *)error
{
	
}

@synthesize tableView = _tableView;

@end

