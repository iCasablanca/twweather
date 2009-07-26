//
//  ZBWeekTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/1/17.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "ZBWeekTableViewController.h"
#import "TWWeatherAPI.h"
#import "TWWeatherAPI+Week.h"
#import "ZBWeekTableViewCell.h"

@implementation ZBWeekTableViewController

- (void)dealloc 
{
	[_weekArray release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
     if (self = [super initWithStyle:style]) {
		 _weekArray = nil;
    }
    return self;
}
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
}
- (void)viewDidLoad
{
	[super viewDidLoad];
	[self.tableView setScrollEnabled:NO];
}
- (void)parse
{
	[[TWWeatherAPI sharedAPI] fetchWeekWithDelegate:self name:_name URLString:_URLString];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    ZBWeekTableViewCell *cell = (ZBWeekTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ZBWeekTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	NSDictionary *d = [_weekArray objectAtIndex:indexPath.row];
	cell.description = [d valueForKey:@"description"];
	cell.date = [d valueForKey:@"date"];
	cell.temperature = [d valueForKey:@"temperature"];
	[cell setImageByCondition];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55.0;
}

#pragma mark ZBWeekDelegate

- (void)weekParsercDidComplete:(TWWeatherAPI *)api name:(NSString *)name week:(NSArray *)week
{
	id tmp = _weekArray;
	_weekArray = [week retain];
	[tmp release];	
	[self.tableView reloadData];
}
- (void)weekParserDidFail:(TWWeatherAPI *)api
{
	[_weekArray release];
	_weekArray = nil;
	[self.tableView reloadData];
	
	UIAlertView *a = [[UIAlertView alloc] initWithTitle:[NSString stringWithUTF8String:"無法載入氣象預報"] message:[NSString stringWithUTF8String:"請檢查您的網路狀態是否正常"] delegate:self cancelButtonTitle:[NSString stringWithUTF8String:"關閉"] otherButtonTitles:nil];
	[a show];
	[a release];
}

@synthesize name = _name;
@synthesize URLString = _URLString;
//@synthesize weekArray = _weekArray;

@end

