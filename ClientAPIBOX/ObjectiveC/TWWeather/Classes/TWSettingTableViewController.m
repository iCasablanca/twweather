//
//  TWSettingTableViewController.m
//  TWWeather
//
//  Created by zonble on 10/13/09.
//  Copyright 2009 Lithoglyph Inc.. All rights reserved.
//

#import "TWSettingTableViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWWeatherAppDelegate+BGM.h"
#import "TWCommonHeader.h"

@implementation TWSettingTableViewController

- (void)removeOutletsAndControls_TWSettingTableViewController
{
    // remove and clean outlets and controls here
	[BGMSwitch release];
	BGMSwitch = nil;
	[loginButton release];
	loginButton = nil;
}

- (void)dealloc 
{
	[self removeOutletsAndControls_TWSettingTableViewController];
    [super dealloc];
}
- (void)viewDidUnload
{
	[super viewDidUnload];
	[self removeOutletsAndControls_TWSettingTableViewController];
}

#pragma mark -
#pragma mark UIViewContoller Methods


- (void)viewDidLoad 
{
    [super viewDidLoad];
	if (!BGMSwitch) {
		BGMSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(190, 8, 80, 40)];
		[BGMSwitch addTarget:self action:@selector(toggleBGMSettingAction:) forControlEvents:UIControlEventValueChanged];
		BGMSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:TWBGMPreferencen];
	}
	if (!loginButton) {
		loginButton = [[FBLoginButton alloc] init];
		loginButton.session = [TWWeatherAppDelegate sharedDelegate].facebookSession;
		loginButton.frame = CGRectMake(200, 3, 80, 40);
	}
	
	self.title = NSLocalizedString(@"Settings", @"");
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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	if (indexPath.section == 0) {
		cell.textLabel.text = NSLocalizedString(@"BGM", @"");
		[cell.contentView addSubview:BGMSwitch];
	}
	else if (indexPath.section == 1) {
		cell.textLabel.text = NSLocalizedString(@"Facebook", @"");
		[cell.contentView addSubview:loginButton];
	}
	cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return NSLocalizedString(@"Basic Settings", @"");
			break;
		case 1:
			return NSLocalizedString(@"Social Network", @"");
			break;			
		default:
			break;
	}
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if (section	== 1) {
		return NSLocalizedString(@"You can share the forecasts with your friends via Facebook!", @"");
	}
	return nil;
}

- (IBAction)toggleBGMSettingAction:(id)sender
{
	UISwitch *aSwitch = (UISwitch *)sender;
	if (aSwitch.on) {
		[[TWWeatherAppDelegate sharedDelegate] startPlayingBGM];
	}
	else {
		[[TWWeatherAppDelegate sharedDelegate] stopPlayingBGM];
	}
	[[NSUserDefaults standardUserDefaults] setBool:aSwitch.on forKey:TWBGMPreferencen];
}


@end

