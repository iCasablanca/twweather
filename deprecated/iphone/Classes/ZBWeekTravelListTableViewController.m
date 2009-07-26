//
//  ZBWeekTravelListTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/1/24.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "ZBWeekTravelListTableViewController.h"
#import "ZBWeekTableViewController.h"

@implementation ZBWeekTravelListTableViewController
- (void)dealloc 
{
	[_weekTravelArray release];
    [super dealloc];
}
- (void)addLocationWithName:(NSString *)name URLString:(NSString *)URLString
{
	NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", URLString, @"URLString", nil];
	[_weekTravelArray addObject:d];	
}
- (void)_init 
{
	_weekTravelArray = [NSMutableArray new];
	[self addLocationWithName:[NSString stringWithUTF8String:"陽明山"] URLString:@"http://www.cwb.gov.tw/mobile/week_travel/Yang-ming-shan.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"拉拉山"] URLString:@"http://www.cwb.gov.tw/mobile/week_travel/Lalashan.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"梨山"] URLString:@"http://www.cwb.gov.tw/mobile/week_travel/Lishan.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"合歡山"] URLString:@"http://www.cwb.gov.tw/mobile/week_travel/Hohuan-shan.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"日月潭"] URLString:@"http://www.cwb.gov.tw/mobile/week_travel/Sun-Moon-Lake.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"溪頭"] URLString:@"http://www.cwb.gov.tw/mobile/week_travel/Hsitou.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"阿里山"] URLString:@"http://www.cwb.gov.tw/mobile/week_travel/Alishan.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"玉山"] URLString:@"http://www.cwb.gov.tw/mobile/week_travel/Yushan.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"墾丁"] URLString:@"http://www.cwb.gov.tw/mobile/week_travel/Kenting.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"龍洞"] URLString:@"http://www.cwb.gov.tw/mobile/week_travel/Lung-tung.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"太魯閣"] URLString:@"http://www.cwb.gov.tw/mobile/week_travel/Taroko.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"三仙台"] URLString:@"http://www.cwb.gov.tw/mobile/week_travel/San-shiantai.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"綠島"] URLString:@"http://www.cwb.gov.tw/mobile/week_travel/Lu-Tao.wml"];
	[self addLocationWithName:[NSString stringWithUTF8String:"蘭嶼"] URLString:@"http://www.cwb.gov.tw/mobile/week_travel/Lanyu.wml"];


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
	self.title = [NSString stringWithUTF8String:"一週旅遊"];
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
	return [_weekTravelArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSDictionary *d = [_weekTravelArray objectAtIndex:indexPath.row];
	NSString *name = [d valueForKey:@"name"];
	cell.text = name;
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	ZBWeekTableViewController *controller = [[ZBWeekTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	NSDictionary *d = [_weekTravelArray objectAtIndex:indexPath.row];
	NSString *title = [NSString stringWithFormat:@"%@%@", [d valueForKey:@"name"], [NSString stringWithUTF8String:"一週旅遊"]];
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
