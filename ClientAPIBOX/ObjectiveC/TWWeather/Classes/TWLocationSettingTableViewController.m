//
// TWLocationSettingTableViewController.m
//
// Copyright (c) 2009 - 2010 Weizhong Yang (http://zonble.net)
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

#import "TWLocationSettingTableViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"

@implementation TWLocationSettingTableViewController

#pragma mark Routines

- (void)dealloc 
{
	[_filterArray release];
	[_addController release];
    [super dealloc];
}

#pragma mark UIViewContoller Methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	if (!_filterArray) {
		_filterArray = [[NSMutableArray alloc] init];
	}
	
	if (!_addController) {
		_addController = [[TWLocationAddTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		_addController.delegate = self;
	}
	
	UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donelAction:)];
	self.navigationItem.rightBarButtonItem = cancelItem;
	[cancelItem release];
	
	self.tableView.editing = YES;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
}

#pragma mark Actions

- (void)setFilter:(NSArray *)filter
{
	if (!_filterArray) {
		_filterArray = [[NSMutableArray alloc] init];
	}	
	[_filterArray setArray:filter];
}
- (IBAction)donelAction:(id)sender
{
	if ([self.navigationController parentViewController]) {
		[[self.navigationController parentViewController] dismissModalViewControllerAnimated:YES];
	}
}

#pragma mark -
#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			if ([_filterArray count] >= [[[TWAPIBox sharedBox] forecastLocations] count]) {
				return 0;
			}
			return 1;
			break;
		case 1:
			return [_filterArray count];
			break;
		default:
			break;
	}
	return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	if (indexPath.section == 0) {
		cell.textLabel.text = NSLocalizedString(@"Add...", @"");
	}
	else {
		NSInteger locationID = [[_filterArray objectAtIndex:indexPath.row] intValue];
		NSString *locationName = [[[[TWAPIBox sharedBox] forecastLocations] objectAtIndex:locationID] objectForKey:@"name"];
		cell.textLabel.text = locationName;	
	}
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return UITableViewCellEditingStyleInsert;
	}	
	return UITableViewCellEditingStyleDelete;	
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return YES;
	}
	else if (indexPath.row == 0 && ([_filterArray count] <= 1)) {
		return NO;
	}	
	return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1) {
		return YES;
	}
	return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSInteger index = indexPath.row;
		[_filterArray removeObjectAtIndex:index];
		if ([_filterArray count] && [_filterArray count] < [[[TWAPIBox sharedBox] forecastLocations] count] - 1) {
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		}
		else {
			[tableView reloadData];
		}
		if (delegate && [delegate respondsToSelector:@selector(settingController:didUpdateFilter:)]) {
			[delegate settingController:self didUpdateFilter:_filterArray];		
		}		
    }  
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
		[_addController updateContentArrayWithFilterArray:_filterArray];
		UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:_addController];
		[self presentModalViewController:controller animated:YES];
		[controller release];
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	if (proposedDestinationIndexPath.section == 0) {
		return sourceIndexPath;
	}
	return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{	
	NSUInteger fromRow = fromIndexPath.row;
	NSUInteger targetRow = toIndexPath.row;
	
	[_filterArray exchangeObjectAtIndex:targetRow withObjectAtIndex:fromRow];	
	if (delegate && [delegate respondsToSelector:@selector(settingController:didUpdateFilter:)]) {
		[delegate settingController:self didUpdateFilter:_filterArray];		
	}	
}

#pragma mark TWLocationAddTableViewController delegate methods

- (void)locationAddTableViewController:(TWLocationAddTableViewController *)controller didSelectedLocationIdentifier:(NSUInteger)locationIdentifier;
{
	NSNumber *number = [NSNumber numberWithInt:locationIdentifier];
	[_filterArray addObject:number];
	[self.tableView reloadData];
	
	if (delegate && [delegate respondsToSelector:@selector(settingController:didUpdateFilter:)]) {
		[delegate settingController:self didUpdateFilter:_filterArray];		
	}	
}

@synthesize delegate;

@end

