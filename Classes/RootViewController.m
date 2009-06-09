//
//  RootViewController.m
//  TWWeather
//
//  Created by zonble on 2009/1/12.
//  Copyright zonble.twbbs.org 2009. All rights reserved.
//

#import "RootViewController.h"
#import "TWWeatherAppDelegate.h"
#import "ZBOverviewViewController.h"
#import "ZBForecastsListTableViewController.h"
#import "ZBWeekListTableViewController.h"
#import "ZBGraphicsListTableViewController.h"
#import "ZBWeekTravelListTableViewController.h"
#import "ZBForecastsArrayController.h"
#import "ZBForecastTableViewCell.h"


@implementation RootViewController

- (void)dealloc 
{
	[_creditLabel release];
	[_footerView release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = [NSString stringWithUTF8String:"台灣天氣"];
	self.tableView.tableFooterView = _footerView;
	_footerView.backgroundColor = [UIColor clearColor];
	_creditLabel.font = [UIFont systemFontOfSize:12.0];
	_creditLabel.text = [NSString stringWithUTF8String:"作者：楊維中（a.k.a zonble）\nzonble@gmail.com\nhttp://zonble.net/\n資料來源：中央氣象局"];
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.tableView setNeedsDisplay];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 3;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		TWWeatherAppDelegate *controller = [UIApplication sharedApplication].delegate;
		return controller.rootTitle;
	}		
	return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	switch (section) {
		case 0:
			return 2;
			break;
		case 1:
			return 5;
			break;			
		case 2:
			return 3;
			break;
		default:
			break;
	}
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.section == 0 && indexPath.row == 0) {
		ZBForecastTableViewCell *cell = [[[ZBForecastTableViewCell alloc] initWithFrame:CGRectZero] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		TWWeatherAppDelegate *controller = [UIApplication sharedApplication].delegate;
		NSDictionary *d = controller.rootDictionary;
		
		if (!d) {
			cell.lackingData = YES;
		}
		else {	
			cell.lackingData = NO;
			cell.title = [d valueForKey:kTimeTitle];
			cell.date = [d valueForKey:kTimeDate];
			cell.temperature = [d valueForKey:kTemperature];
			cell.rain = [d valueForKey:kRain];
			cell.description = [d valueForKey:kDescription];
			[cell setiImageByCondition];
		}

		return cell;
	}
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 1:
				cell.text = [NSString stringWithUTF8String:"切換目前所在地位置"];
				break;
			default:
				break;
		}	
	}
	else if (indexPath.section == 1) {
		cell.image = [UIImage imageNamed:@"ball.png"];
		cell.font = [UIFont boldSystemFontOfSize:18.0];
		switch (indexPath.row) {
			case 0:
				cell.text = [NSString stringWithUTF8String:"關心天氣"];
				break;
			case 1:
				cell.text = [NSString stringWithUTF8String:"今明預報"];
				break;
			case 2:
				cell.text = [NSString stringWithUTF8String:"一週天氣"];
				break;				
			case 3:
				cell.text = [NSString stringWithUTF8String:"一週旅遊"];
				break;
			case 4:
				cell.text = [NSString stringWithUTF8String:"天氣雲圖"];
				break;				
			default:
				break;
		}		
	}
	else if (indexPath.section == 2) {
		cell.image = [UIImage imageNamed:@"ball.png"];
		cell.font = [UIFont boldSystemFontOfSize:14.0];
		switch (indexPath.row) {
			case 0:
				cell.text = [NSString stringWithUTF8String:"氣象查詢電話：02-23491234"];
				break;
			case 1:
				cell.text = [NSString stringWithUTF8String:"地震查詢電話：02-23491168"];
				break;
			case 2:
				cell.text = [NSString stringWithUTF8String:"中央氣象局網站"];
				break;
			default:
				break;
		}		
	}
    
    // Set up the cell...

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 0) {
		if (indexPath.row == 1) {
			TWWeatherAppDelegate *controller = [UIApplication sharedApplication].delegate;
			[controller showLocationPicker];
		}
	}
	else if (indexPath.section == 1) {
		switch (indexPath.row) {
			case 0:
			{
				ZBOverviewViewController *controller = [[ZBOverviewViewController alloc] initWithNibName:@"ZBOverviewViewController" bundle:[NSBundle mainBundle]];
				[self.navigationController pushViewController:controller animated:YES];
				[controller release];
				[controller parse];
			}
				break;
			case 1:
			{
				ZBForecastsListTableViewController *controller = [[ZBForecastsListTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
				[self.navigationController pushViewController:controller animated:YES];
				[controller release];			
			}
				break;
			case 2: 
			{
				ZBWeekListTableViewController *controller = [[ZBWeekListTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
				[self.navigationController pushViewController:controller animated:YES];
				[controller release];			
			}
				break;
			case 3:
			{
				ZBWeekTravelListTableViewController *controller = [[ZBWeekTravelListTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
				[self.navigationController pushViewController:controller animated:YES];
				[controller release];				
			}
				break;
			case 4: 
			{
				ZBGraphicsListTableViewController *controller = [[ZBGraphicsListTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
				[self.navigationController pushViewController:controller animated:YES];
				[controller release];			
			}
				break;
			default:
				break;
		}
	}
	else if (indexPath.section == 2) {
		NSURL *URL = nil;
		switch (indexPath.row) {
			case 0:
				URL = [NSURL URLWithString:@"tel://886223491234"];
				break;
			case 1:
				URL = [NSURL URLWithString:@"tel://886223491168"];
				break;
			case 2: 
				URL = [NSURL URLWithString:@"http://www.cwb.gov.tw"];
				break;
			default:
				break;
		}
		[[UIApplication sharedApplication] openURL:URL];
	}
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1)
		return UITableViewCellAccessoryDisclosureIndicator;
	return UITableViewCellAccessoryNone;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && indexPath.row == 0)
		return 120.0;
	return 44.0;
}

//@synthesize tableView = _tableView;

@end

