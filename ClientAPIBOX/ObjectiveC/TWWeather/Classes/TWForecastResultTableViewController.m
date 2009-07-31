//
//  TWForecastResultTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import "TWForecastResultTableViewController.h"
#import "TWForecastResultCell.h"
#import "TWAPIBox.h"

@implementation TWForecastResultTableViewController

- (void)dealloc 
{
	self.forecastArray = nil;
    [super dealloc];
}

#pragma mark UIViewContoller Methods

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
    
    TWForecastResultCell *cell = (TWForecastResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TWForecastResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	NSDictionary *dictionary = [forecastArray objectAtIndex:indexPath.row];
    cell.title = [dictionary objectForKey:@"title"];
	cell.description = [dictionary objectForKey:@"description"];
	cell.rain = [dictionary objectForKey:@"rain"];
	cell.temperature = [dictionary objectForKey:@"temperature"];
	NSString *beginTimeString = [dictionary objectForKey:@"beginTime"];
	NSDate *beginDate = [[TWAPIBox sharedBox] dateFromString:beginTimeString];
	cell.beginTime = [[TWAPIBox sharedBox] shortStringFromDate:beginDate];
	NSString *endTimeString = [dictionary objectForKey:@"endTime"];
	NSDate *endDate = [[TWAPIBox sharedBox] dateFromString:endTimeString];
	cell.endTime = [[TWAPIBox sharedBox] shortStringFromDate:endDate];
	[cell setNeedsDisplay];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 130.0;
}


@synthesize forecastArray;

@end

