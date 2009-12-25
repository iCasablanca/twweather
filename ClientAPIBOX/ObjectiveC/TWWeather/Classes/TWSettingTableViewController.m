//
// TWSettingTableViewController.m
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

#import "TWSettingTableViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWWeatherAppDelegate+BGM.h"
#import "TWPlurkSettingTableViewController.h"
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
	[self.tableView reloadData];
}
//- (void)viewWillDisappear:(BOOL)animated 
//{
//	[super viewWillDisappear:animated];
//}
//- (void)viewDidDisappear:(BOOL)animated 
//{
//	[super viewDidDisappear:animated];
//}


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
	switch (section) {
		case 0:
			return 1;
			break;
		case 1:
			return 2;
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryType = UITableViewCellAccessoryNone;
	if (indexPath.section == 0) {
		cell.textLabel.text = NSLocalizedString(@"BGM", @"");
		[cell.contentView addSubview:BGMSwitch];
	}
	else if (indexPath.section == 1) {
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = NSLocalizedString(@"Facebook", @"");
				[cell.contentView addSubview:loginButton];
				break;
			case 1:
				cell.textLabel.text = NSLocalizedString(@"Plurk", @"");
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				if ([[ObjectivePlurk sharedInstance] isLoggedIn]) {
					cell.detailTextLabel.text = NSLocalizedString(@"Logged In", @"");
				}
				else {
					cell.detailTextLabel.text = NSLocalizedString(@"Not Logged In", @"");
				}

				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				break;
			default:
				break;
		}
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1 && indexPath.row == 1) {
		TWPlurkSettingTableViewController *controller = [[TWPlurkSettingTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
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

