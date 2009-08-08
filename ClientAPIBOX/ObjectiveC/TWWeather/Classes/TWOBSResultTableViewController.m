//
//  TWOBSResultTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/08.
//

#import "TWOBSResultTableViewController.h"
#import "TWOBSCell.h"
#import "TWAPIBox.h"

@implementation TWOBSResultTableViewController

- (void)dealloc 
{
	[description release];
	[rain release];
	[temperature release];
	[time release];
	[windDirection release];
	[windLevel release];
	[windStrongestLevel release];
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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    TWOBSCell *cell = (TWOBSCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TWOBSCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.description = self.description;
	cell.rain = self.rain;
	cell.temperature = self.temperature;
	cell.windDirection = self.windDirection;
	cell.windLevel = self.windLevel;
	cell.windStrongestLevel = self.windStrongestLevel;
	
	[cell setNeedsDisplay];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 320.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"地面觀測資料";
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSDate *theDate = [[TWAPIBox sharedBox] dateFromString:self.time];
	return [[TWAPIBox sharedBox] shortDateTimeStringFromDate:theDate];
}

@synthesize description;
@synthesize rain;
@synthesize temperature;
@synthesize time;
@synthesize windDirection;
@synthesize windLevel;
@synthesize windStrongestLevel;

@end

