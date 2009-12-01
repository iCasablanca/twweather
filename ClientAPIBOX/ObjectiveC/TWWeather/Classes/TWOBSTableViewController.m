//
// TWOBSTableViewController.m
//
// Copyright (c) 2009 Weizhong Yang (http://zonble.net)
// All Rights Reserved
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of Weizhong Yang (zonble) nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY WEIZHONG YANG ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL WEIZHONG YANG BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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

#pragma mark -

- (void)resetLoading
{
	for (NSMutableDictionary *d in _filteredArray) {
		[d setObject:[NSNumber numberWithBool:NO] forKey:@"isLoading"];
	}
	for (NSDictionary *d in _locations) {
		NSArray *items = [d objectForKey:@"items"];
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
		controller.windScale = [result objectForKey:@"windScale"];
		controller.gustWindScale = [result objectForKey:@"gustWindScale"];		
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

