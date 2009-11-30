//
//  TWForecastResultTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import "TWForecastResultTableViewController.h"
#import "TWForecastResultCell.h"
#import "TWWeekResultTableViewController.h"
#import "TWErrorViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWLoadingCell.h"
#import "TWAPIBox.h"

@implementation TWForecastResultTableViewController

- (void)dealloc 
{
	self.forecastArray = nil;
	self.weekLocation = nil;
	self.weekDictionary = nil;
    [super dealloc];
}

#pragma mark UIViewContoller Methods

- (void)viewDidLoad
{
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(navBarAction:)];
	self.navigationItem.rightBarButtonItem = item;
	[item release];	
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[TWAPIBox sharedBox] cancelAllRequestWithDelegate:self];
}
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (IBAction)navBarAction:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Share via Facebook", @""), nil];
	[actionSheet showInView:[self view]];
	[actionSheet release];
}
- (void)shareViaFacebook
{
	if ([[TWWeatherAppDelegate sharedDelegate] confirmFacebookLoggedIn]) {
		FBStreamDialog *dialog = [[[FBStreamDialog alloc] init] autorelease];
		dialog.delegate = [TWWeatherAppDelegate sharedDelegate];
		
		NSString *feedTitle = [NSString stringWithFormat:@"%@ 四十八小時天氣預報", [self title]];
		NSMutableString *description = [NSMutableString string];
		for (NSDictionary *forecast in forecastArray) {
			[description appendFormat:@"※ %@", [forecast valueForKey:@"title"]];
			[description appendFormat:@"(%@ - %@) ", [forecast valueForKey:@"beginTime"], [forecast valueForKey:@"endTime"]];
			[description appendFormat:@"%@ ", [forecast valueForKey:@"description"]];
			[description appendFormat:@"降雨機率：%@ ", [forecast valueForKey:@"rain"]];
			[description appendFormat:@"氣溫：%@", [forecast valueForKey:@"temperature"]];

		}
		NSString *attachment = [NSString stringWithFormat:@"{\"name\":\"%@\", \"description\":\"%@\"}", feedTitle, description];
		dialog.attachment = attachment;
		dialog.userMessagePrompt = feedTitle;
		[dialog show];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (!buttonIndex) {
		[self shareViaFacebook];
	}
}



#pragma mark -
#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (weekLocation) {
		return 2;
	}
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return [forecastArray count];
	}
	else if (section == 1) {
		return 1;
	}	
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	static NSString *CellIdentifier = @"Cell";
	static NSString *NormalIdentifier = @"NormalCell";
	if (indexPath.section == 0) {
		TWForecastResultCell *cell = (TWForecastResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[TWForecastResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		NSDictionary *dictionary = [forecastArray objectAtIndex:indexPath.row];
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
		TWLoadingCell *cell = (TWLoadingCell *)[tableView dequeueReusableCellWithIdentifier:NormalIdentifier];
		if (cell == nil) {
			cell = [[[TWLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalIdentifier] autorelease];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.text = @"一週預報";
		
		if (isLoadingWeek) {
			[cell startAnimating];
		}
		else {
			[cell stopAnimating];
		}
		
		return cell;
	}	
	return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return 130.0;
	}
	return 45.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1) {
		if (weekDictionary) {
			[self pushWeekViewController];
			return;
		}
		isLoadingWeek = YES;
		[self.tableView reloadData];
		[[TWAPIBox sharedBox] fetchWeekWithLocationIdentifier:self.weekLocation delegate:self userInfo:nil];
	}
}

#pragma mark -
#pragma mark TWWeatherAPI delegate

- (void)pushWeekViewController
{
	TWWeekResultTableViewController *controller = [[TWWeekResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.title = [self.weekDictionary objectForKey:@"locationName"];
	controller.forecastArray = [self.weekDictionary objectForKey:@"items"];
	NSString *dateString = [self.weekDictionary objectForKey:@"publishTime"];
	NSDate *date = [[TWAPIBox sharedBox] dateFromShortString:dateString];
	controller.publishTime = [[TWAPIBox sharedBox] shortDateTimeStringFromDate:date];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}
- (void)pushErrorViewWithError:(NSError *)error
{
	TWErrorViewController *controller = [[TWErrorViewController alloc] init];
	controller.error = error;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchWeek:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	isLoadingWeek = NO;
	[self.tableView reloadData];

	if ([result isKindOfClass:[NSDictionary class]]) {
		self.weekDictionary = result;
		[self pushWeekViewController];
	}
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWeekWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	isLoadingWeek = NO;
	[self.tableView reloadData];
	
	[self pushErrorViewWithError:error];
}


@synthesize forecastArray;
@synthesize weekLocation;
@synthesize weekDictionary;

@end

