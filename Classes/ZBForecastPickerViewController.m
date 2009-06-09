//
//  ZBForecastPickerViewController.m
//  TWWeather
//
//  Created by zonble on 2009/1/14.
//  Copyright 2009 i. All rights reserved.
//

#import "ZBForecastPickerViewController.h"
#import "TWWeatherAppDelegate.h"

@implementation ZBForecastPickerViewController

- (void)dealloc 
{
	[_toolbar release];
	[_tableView release];
	[_arrayController release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
	self = [super initWithNibName:nibName bundle:nibBundle];
	if (self != nil) {
		_arrayController = [ZBForecastsArrayController new];
	}
	return self;
}
- (void)viewDidLoad 
{
    [super viewDidLoad];
	_toolbar.tintColor = [UIColor grayColor];
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[_tableView reloadData];
	NSInteger selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreferenceName];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
	[_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (IBAction)closeAction:(id)sender
{
	TWWeatherAppDelegate *controller = [UIApplication sharedApplication].delegate;
	[controller hideLocationPicker];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary *d = [_arrayController.array objectAtIndex:indexPath.row];
	NSString *name = [d valueForKey:@"name"];
	cell.text = name;
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	NSInteger selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreferenceName];
	if (indexPath.row == selectedIndex)
		cell.textColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.5 alpha:1.0];
	else
		cell.textColor = [UIColor blackColor];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:kLocationPreferenceName];
	TWWeatherAppDelegate *controller = [UIApplication sharedApplication].delegate;
	[controller updateRootForecast];	
	[self closeAction:nil];
}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSInteger selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kLocationPreferenceName];
	if (selectedIndex == indexPath.row) {
		return UITableViewCellAccessoryCheckmark;
	}
	return UITableViewCellAccessoryNone;
}

@end

