//
//  TWThreeDaySeaResultTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWThreeDaySeaResultTableViewController.h"
#import "TWThreeDaySeaCell.h"
#import "TWAPIBox.h"

@implementation TWThreeDaySeaResultTableViewController

- (void)dealloc 
{
	[forecastArray release];
	[publishTime release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [forecastArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    TWThreeDaySeaCell *cell = (TWThreeDaySeaCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TWThreeDaySeaCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	NSDictionary *dictionary = [forecastArray objectAtIndex:indexPath.row];
	NSString *dateString = [dictionary objectForKey:@"date"];
	NSDate *date = [[TWAPIBox sharedBox] dateFromShortString:dateString];
	cell.date = [[TWAPIBox sharedBox] shortDateStringFromDate:date];	
	cell.description = [dictionary objectForKey:@"description"];
	cell.wind = [dictionary objectForKey:@"wind"];
	cell.windLevel = [dictionary objectForKey:@"windLevel"];
	cell.wave = [dictionary objectForKey:@"wave"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell setNeedsDisplay];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 120.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *time = [NSString stringWithFormat:@"發布時間：%@", publishTime];
	return time;
}

@synthesize forecastArray;
@synthesize publishTime;

@end

