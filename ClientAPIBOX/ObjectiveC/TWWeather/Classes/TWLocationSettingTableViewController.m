//
// TWLocationSettingTableViewController.m
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

#import "TWLocationSettingTableViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"

@implementation TWLocationSettingTableViewController

- (void)dealloc 
{
	[_filterArray release];
    [super dealloc];
}

#pragma mark UIViewContoller Methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
//	self.title = @"My Favorites";
	
	if (!_filterArray) {
		_filterArray = [[NSMutableArray alloc] init];
	}
	
	UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donelAction:)];
	self.navigationItem.rightBarButtonItem = cancelItem;
	[cancelItem release];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
- (void)setFilter:(NSArray *)filter
{
	if (!_filterArray) {
		_filterArray = [[NSMutableArray alloc] init];
	}	
	[_filterArray setArray:filter];
}
- (IBAction)donelAction:(id)sender
{
	if (delegate && [delegate respondsToSelector:@selector(settingController:didUpdateFilter:)]) {
		[delegate settingController:self didUpdateFilter:_filterArray];		
	}
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
	NSNumber *number = [NSNumber numberWithInt:indexPath.row];
	if ([_filterArray containsObject:number]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSNumber *number = [NSNumber numberWithInt:indexPath.row];
	if ([_filterArray containsObject:number]) {
		if ([_filterArray count] == 1 && [_filterArray objectAtIndex:0] == number) {
			return;
		}
		[_filterArray removeObject:number];
	}
	else {
		[_filterArray addObject:number];
	}
	[self.tableView reloadData];
}

@synthesize delegate;

@end

