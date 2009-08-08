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
#import "TWLoadingCell.h"
#import "TWAPIBox+Info.h"

@implementation TWOBSTableViewController

- (void)dealloc 
{
    [super dealloc];
}

- (void)_init
{
	if (!_array) {
		_array = [[NSMutableArray alloc] init];
		NSArray *allLocations = [[TWAPIBox sharedBox] OBSLocations];
		for (NSDictionary *d in allLocations) {
			NSArray *items = [d objectForKey:@"items"];
			for (NSDictionary *item in items) {
				NSMutableDictionary *newItem = [NSMutableDictionary dictionaryWithDictionary:item];
				[newItem setObject:[NSNumber numberWithBool:NO] forKey:@"isLoading"];
				[_array addObject:newItem];
			}
		}
	}
	if (!_filteredArray) {
		_filteredArray = [[NSMutableArray alloc] init];
	}
	
	if (!_locations) {
		_locations = [[NSMutableArray alloc] init];
		NSArray *allLocations = [[TWAPIBox sharedBox] OBSLocations];
		for (NSDictionary *d in allLocations) {
			NSMutableDictionary *category = [NSMutableDictionary dictionary];
			[category setObject:[d objectForKey:@"AreaID"] forKey:@"AreaID"];
			[category setObject:[d objectForKey:@"areaName"] forKey:@"areaName"];
			NSMutableArray *items = [NSMutableArray array];
			for (NSDictionary *item in [d objectForKey:@"items"]) {
				NSMutableDictionary *newItem = [NSMutableDictionary dictionaryWithDictionary:item];
				[newItem setObject:[NSNumber numberWithBool:NO] forKey:@"isLoading"];
				[items addObject:newItem];
			}
			[category setObject:items forKey:@"items"];
			[_locations addObject:category];
		}
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
	else if (tableView == self.searchDisplayController.searchResultsTableView) {
		return 1;
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
	else if (tableView == self.searchDisplayController.searchResultsTableView) {
		return [_filteredArray count];
	}	
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.tableView) {
		NSDictionary *sectionDictionary = [_locations objectAtIndex:section];
		return [sectionDictionary objectForKey:@"areaName"];
	}
	return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    TWLoadingCell *cell = (TWLoadingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TWLoadingCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	NSDictionary *dictionary = nil;
	if (tableView == self.tableView) {
		NSDictionary *sectionDictionary = [_locations objectAtIndex:indexPath.section];
		NSArray *items = [sectionDictionary objectForKey:@"items"];
		dictionary = [items objectAtIndex:indexPath.row];
	}
	else if (tableView == self.searchDisplayController.searchResultsTableView) {
		dictionary = [_filteredArray objectAtIndex:indexPath.row];
	}
	if (!dictionary) {
		return cell;
	}
	cell.textLabel.text = [dictionary objectForKey:@"name"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	if ([[dictionary objectForKey:@"isLoading"] boolValue]) {
		[cell startAnimating];
	}
	else {
		[cell stopAnimating];
	}
	
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSMutableDictionary *dictionary  = nil;
	if (tableView == self.tableView) {
		NSDictionary *sectionDictionary = [_locations objectAtIndex:indexPath.section];
		NSArray *items = [sectionDictionary objectForKey:@"items"];
		dictionary = [items objectAtIndex:indexPath.row];
	}
	else {
		dictionary = [_filteredArray objectAtIndex:indexPath.row];	
	}
	if (dictionary) {	
		NSString *identifier = [dictionary objectForKey:@"identifier"];		
		[dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isLoading"];
		self.tableView.userInteractionEnabled = NO;
		[self.tableView reloadData];		
		[[TWAPIBox sharedBox] fetchOBSWithLocationIdentifier:identifier delegate:self userInfo:nil];		
	}
}
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//	if (tableView == self.tableView) {
//		NSMutableArray *array = [NSMutableArray array];
//		for (NSDictionary *d in _locations) {
//			NSString *name = [d objectForKey:@"areaName"];
//			NSString *title = [name substringToIndex:1];
//			if (!title) {
//				title = @"";
//			}
//			[array addObject:title];
//		}
//		return array;
//	}
//	
//	return nil;
//}
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//	if (tableView == self.tableView) {
//		return index;
//	}
//	return 0;
//}

#pragma mark -

- (void)resetLoading
{
	for (NSMutableDictionary *d in _filteredArray) {
		[d setObject:[NSNumber numberWithBool:NO] forKey:@"isLoading"];
	}
	for (NSDictionary *d in _locations) {
		NSArray *items = [d valueForKey:@"items"];
		for (NSMutableDictionary *item in items) {
			[item setObject:[NSNumber numberWithBool:NO] forKey:@"isLoading"];
		}		
	}
	[self.tableView reloadData];
	[_searchController.searchResultsTableView reloadData];
	self.tableView.userInteractionEnabled = YES;
	_searchController.searchResultsTableView.userInteractionEnabled = YES;	
}

#pragma mark -

- (void)APIBox:(TWAPIBox *)APIBox didFetchOBS:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	[self resetLoading];
	
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
	[self resetLoading];
	[self pushErrorViewWithError:error];
}



@end

