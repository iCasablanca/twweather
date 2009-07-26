//
//  ZBWeekTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/1/17.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "ZBWeekListTableViewController.h"
#import "ZBWeekTableViewController.h"

@implementation ZBWeekListTableViewController

- (void)dealloc 
{
	[_weekArray release];
    [super dealloc];
}
- (void)addLocationWithName:(NSString *)name URLString:(NSString *)URLString
{
	NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", URLString, @"URLString", nil];
	[_weekArray addObject:d];	
}
- (void)_init 
{
	_weekArray = [NSMutableArray new];
	[self addLocationWithName:[NSString stringWithUTF8String:"台北市"] URLString:@"http://www.cwb.gov.tw/mobile/week/Taipei.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"北部"] URLString:@"http://www.cwb.gov.tw/mobile/week/North.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"中部"] URLString:@"http://www.cwb.gov.tw/mobile/week/Center.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"南部"] URLString:@"http://www.cwb.gov.tw/mobile/week/South.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"東北部"] URLString:@"http://www.cwb.gov.tw/mobile/week/North-East.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"東部"] URLString:@"http://www.cwb.gov.tw/mobile/week/East.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"東南部"] URLString:@"http://www.cwb.gov.tw/mobile/week/South-East.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"澎湖"] URLString:@"http://www.cwb.gov.tw/mobile/week/Penghu.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"金門"] URLString:@"http://www.cwb.gov.tw/mobile/week/Kinmen.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"馬祖"] URLString:@"http://www.cwb.gov.tw/mobile/week/Matsu.wml"];
}
- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self != nil) {
		[self _init];
	}
	return self;
}
- (void)viewDidLoad 
{
	[super viewDidLoad];
	self.title = [NSString stringWithUTF8String:"一週天氣"];
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
	return [_weekArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSDictionary *d = [_weekArray objectAtIndex:indexPath.row];
	NSString *name = [d valueForKey:@"name"];
	cell.text = name;
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	ZBWeekTableViewController *controller = [[ZBWeekTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	NSDictionary *d = [_weekArray objectAtIndex:indexPath.row];
	NSString *title = [NSString stringWithFormat:@"%@%@", [d valueForKey:@"name"], [NSString stringWithUTF8String:"一週天氣"]];
	controller.title = title;
	controller.URLString = [d valueForKey:@"URLString"];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	[controller parse];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}

@end

