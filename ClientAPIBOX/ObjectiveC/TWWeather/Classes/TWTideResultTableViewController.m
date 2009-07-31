//
//  TWTideResultTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWTideResultTableViewController.h"
#import "TWTideCell.h"
#import "TWAPIBox.h"

@implementation TWTideResultTableViewController

- (void)dealloc 
{
	[forecastArray release];
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
    
    TWTideCell *cell = (TWTideCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TWTideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	NSDictionary *dictionary = [forecastArray objectAtIndex:indexPath.row];
	
	NSString *dateString = [dictionary objectForKey:@"date"];
	NSDate *date = [[TWAPIBox sharedBox] dateFromShortString:dateString];
	cell.dateString = [[TWAPIBox sharedBox] shortDateStringFromDate:date];
	cell.lunarDateString = [dictionary objectForKey:@"lunarDate"];
	NSDictionary *low = [dictionary objectForKey:@"low"];
	NSDictionary *high = [dictionary objectForKey:@"high"];
	cell.lowHeight = [low objectForKey:@"height"];
	cell.lowShortTime = [low objectForKey:@"shortTime"];
	cell.highHeight = [high objectForKey:@"height"];
	cell.highshortTime = [high objectForKey:@"shortTime"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell setNeedsDisplay];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 120.0;
}


@synthesize forecastArray;

@end

