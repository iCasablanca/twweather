//
//  TWLocationSettingTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWLocationSettingTableViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"

@implementation TWLocationSettingTableViewController

- (void)dealloc 
{
    [super dealloc];
}

#pragma mark UIViewContoller Methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.title = @"變更預設區域";
	
	UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
	self.navigationItem.rightBarButtonItem = cancelItem;
	[cancelItem release];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
- (IBAction)cancelAction:(id)sender
{
	if ([self.navigationController parentViewController]) {
		[[self.navigationController parentViewController] dismissModalViewControllerAnimated:YES];
	}
}

#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[TWAPIBox sharedBox] forecastLocations] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary *dictionary = [[[TWAPIBox sharedBox] forecastLocations] objectAtIndex:indexPath.row];
	NSString *name = [dictionary objectForKey:@"name"];
	cell.textLabel.text = name;
	NSUInteger i = [[NSUserDefaults standardUserDefaults] integerForKey:currentLocationPreference];
	if (i == indexPath.row) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSUInteger i = [[NSUserDefaults standardUserDefaults] integerForKey:currentLocationPreference];
	if (i != indexPath.row) {
		[[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:currentLocationPreference];
		[[TWWeatherAppDelegate sharedDelegate] fetchForecastOFCurrentLocation];
	}
	
	[self cancelAction:self];
}

@end

