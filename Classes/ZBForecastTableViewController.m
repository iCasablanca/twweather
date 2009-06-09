//
//  ZBForecastTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/1/13.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "ZBForecastTableViewController.h"
#import "ZBForecastTableViewCell.h"
#import "TWWeatherAPI.h"
#import "TWWeatherAPI+ForecastParser.h"

@implementation ZBForecastTableViewController

- (void)dealloc 
{
    [super dealloc];
	[_URLString release];
	[_name release];
	[_forecasts release];
}
- (void)_init
{
	_URLString = nil;
	_name = nil;
	_forecasts = nil;
}
- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	if (self != nil) {
		[self _init];
	}
	return self;
}
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
	self = [super initWithNibName:nibName bundle:nibBundle];
	if (self != nil) {
		[self _init];
	}
	return self;
}
- (id)initWithStyle:(UITableViewStyle)style 
{
	self = [super initWithStyle:style];
	if (self != nil) {
		[self _init];
	}
    return self;
}
- (void)parse
{
	[[TWWeatherAPI sharedAPI] fetchForecastWithDelegate:self name:_name URLString:_URLString];
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
	self.tableView.rowHeight = 130.0;
	self.tableView.scrollEnabled = NO;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [_forecasts count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    ZBForecastTableViewCell *cell = (ZBForecastTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ZBForecastTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
	NSDictionary *d = [_forecasts objectAtIndex:indexPath.row];
	cell.title = [d valueForKey:kTimeTitle];
	cell.date = [d valueForKey:kTimeDate];
	cell.temperature = [d valueForKey:kTemperature];
	cell.rain = [d valueForKey:kRain];
	cell.description = [d valueForKey:kDescription];
	[cell setiImageByCondition];

    return cell;
}
- (void)foreCastParserDidComplete:(TWWeatherAPI *)api name:(NSString *)name forecasts:(NSArray *)forecasts;
{
	self.forecasts = forecasts;
	[self.tableView reloadData];
}
- (void)foreCastParserDidFail:(TWWeatherAPI *)api
{
	self.forecasts = nil;
	[self.tableView reloadData];	
	UIAlertView *a = [[UIAlertView alloc] initWithTitle:[NSString stringWithUTF8String:"無法取得天氣預報"] message:[NSString stringWithUTF8String:"請檢查網路狀態是否正確"] delegate:self cancelButtonTitle:[NSString stringWithUTF8String:"關閉"] otherButtonTitles:nil];
	[a show];
	[a release];
}

@synthesize URLString = _URLString;
@synthesize name = _name;
@synthesize forecasts = _forecasts;

- (void)setName:(NSString *)name
{
	id tmp = _name;
	_name = [name retain];
	[tmp release];
	self.title = name;
}

@end

