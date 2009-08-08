//
//  TWOBSTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/07.
//  Copyright 2009 Lithoglyph Inc.. All rights reserved.
//

#import "TWOBSTableViewController.h"
#import "TWOBSResultTableViewController.h"
#import "TWErrorViewController.h"
#import "TWAPIBox+Info.h"

@implementation TWOBSTableViewController

- (void)dealloc 
{
    [super dealloc];
}

- (void)_init
{
	if (!_locations) {
		_locations = [[NSMutableArray alloc] init];
		[_locations setArray:[[TWAPIBox sharedBox] OBSLocations]];
	}
}

- (id)initWithStyle:(UITableViewStyle)style
{
	if (self = [super initWithStyle:style]) {
		[self _init];
	}
	return self;
}
- (id)initWithCoder:(NSCoder *)decoder
{
	if (self = [super initWithCoder:decoder]) {
		[self _init];
	}
	return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self _init];
	}
	return self;
}

#pragma mark UIViewContoller Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"目前天氣";
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
	if (tableView == self.tableView) {
		NSInteger count = [_locations count];
		if (count) {
			return count;
		}
	}
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.tableView) {
		NSDictionary *sectionDictionary = [_locations objectAtIndex:section];
		NSArray *items = [sectionDictionary objectForKey:@"items"];
		NSInteger count = [items count];
		if (count) {
			return count;
		}
	}	
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSDictionary *sectionDictionary = [_locations objectAtIndex:section];
	return [sectionDictionary objectForKey:@"areaName"];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	if (tableView == self.tableView) {
		NSDictionary *sectionDictionary = [_locations objectAtIndex:indexPath.section];
		NSArray *items = [sectionDictionary objectForKey:@"items"];
		NSDictionary *dictionary = [items objectAtIndex:indexPath.row];
		cell.textLabel.text = [dictionary objectForKey:@"name"];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (tableView == self.tableView) {
		NSDictionary *sectionDictionary = [_locations objectAtIndex:indexPath.section];
		NSArray *items = [sectionDictionary objectForKey:@"items"];
		NSDictionary *dictionary = [items objectAtIndex:indexPath.row];
		NSString *identifier = [dictionary objectForKey:@"identifier"];
		[[TWAPIBox sharedBox] fetchOBSWithLocationIdentifier:identifier delegate:self userInfo:nil];
	}
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchOBS:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
//	NSLog(@"result:%@", [result description]);
	if ([result isKindOfClass:[NSDictionary class]]) {
		TWOBSResultTableViewController *controller = [[TWOBSResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		controller.title = [result objectForKey:@"locationName"];
		controller.description = [result objectForKey:@"description"];
		controller.rain = [result objectForKey:@"rain"];
		controller.temperature = [result objectForKey:@"temperature"];
		controller.time = [result objectForKey:@"time"];
		controller.windDirection = [result objectForKey:@"windDirection"];
		controller.windLevel = [result objectForKey:@"windLevel"];
		controller.windStrongestLevel = [result objectForKey:@"windStrongestLevel"];		
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchOBSWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	TWErrorViewController *controller = [[TWErrorViewController alloc] init];
	controller.error = error;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];	
}



@end

