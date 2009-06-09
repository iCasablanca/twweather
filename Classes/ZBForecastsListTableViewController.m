//
//  ZBForecastsListTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/1/13.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "ZBForecastsListTableViewController.h"
#import "ZBForecastTableViewController.h"

@implementation ZBForecastsListTableViewController

- (void)dealloc 
{
	[_arrayController release];
    [super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	_arrayController = [ZBForecastsArrayController new];
	self.title = [NSString stringWithUTF8String:"天氣預報"];
}
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [_arrayController.array count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	NSDictionary *d = [_arrayController.array objectAtIndex:indexPath.row];
	NSString *name = [d valueForKey:@"name"];
	cell.text = name;
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSDictionary *d = [_arrayController.array objectAtIndex:indexPath.row];
	NSString *name = [d valueForKey:@"name"];
	NSString *URLString = [d valueForKey:@"URLString"];

	ZBForecastTableViewController *controller = [[ZBForecastTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[self.navigationController pushViewController:controller animated:YES];
	controller.name = name;
	controller.URLString = URLString;
	[controller parse];
	[controller release];
}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}
@end

