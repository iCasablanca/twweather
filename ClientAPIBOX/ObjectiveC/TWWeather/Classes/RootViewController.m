//
//  RootViewController.m
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import "RootViewController.h"
#import "TWForecastTableViewController.h"
#import "TWWeekTableViewController.h"
#import "TWWeekTravelTableViewController.h"
#import "TWThreeDaySeaTableViewController.h"
#import "TWNearSeaTableViewController.h"
#import "TWTideTableViewController.h"

@implementation RootViewController

- (void) dealloc
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
	self.title = @"台灣天氣";
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (section == 0) {
		return 0;
	}
	else if (section == 1) {
		return 6;
	}
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if (indexPath.section == 1) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"今明預報";
				break;
			case 1:
				cell.textLabel.text = @"一週天氣";
				break;				
			case 2:
				cell.textLabel.text = @"一週旅遊";
				break;				
			case 3:
				cell.textLabel.text = @"三天漁業";
				break;				
			case 4:
				cell.textLabel.text = @"台灣近海";
				break;				
			case 5:
				cell.textLabel.text = @"三天潮汐";
				break;				
			default:
				break;
		}
	}
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.section == 1) {
		UITableViewController *controller = nil;
		if (indexPath.row == 0) {
			controller = [[TWForecastTableViewController alloc] initWithStyle:UITableViewStylePlain];
		}
		else if (indexPath.row == 1) {
			controller = [[TWWeekTableViewController alloc] initWithStyle:UITableViewStylePlain];
		}
		else if (indexPath.row == 2) {
			controller = [[TWWeekTravelTableViewController alloc] initWithStyle:UITableViewStylePlain];
		}
		else if (indexPath.row == 3) {
			controller = [[TWThreeDaySeaTableViewController alloc] initWithStyle:UITableViewStylePlain];
		}
		else if (indexPath.row == 4) {
			controller = [[TWNearSeaTableViewController alloc] initWithStyle:UITableViewStylePlain];
		}
		else if (indexPath.row == 5) {
			controller = [[TWTideTableViewController alloc] initWithStyle:UITableViewStylePlain];
		}
		if (controller) {
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
	}
}

@end

