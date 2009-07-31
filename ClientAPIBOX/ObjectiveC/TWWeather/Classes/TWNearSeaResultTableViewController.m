//
//  TWNearSeaResultViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWNearSeaResultTableViewController.h"
#import "TWNearSeaCell.h"

@implementation TWNearSeaResultTableViewController

- (void)dealloc 
{
	[publishTime release];
	[description release];
	[validBeginTime release];
	[validEndTime release];
	[wave release];
	[waveLevel release];
	[wind release];
	[windLevel release];
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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    TWNearSeaCell *cell = (TWNearSeaCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TWNearSeaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.description = self.description;
	cell.validBeginTime = self.validBeginTime;
	cell.validEndTime = self.validEndTime;
	cell.wave = self.wave;
	cell.waveLevel = self.waveLevel;
	cell.wind = self.wind;
	cell.windLevel = self.windLevel;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell setNeedsDisplay];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 320.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *time = [NSString stringWithFormat:@"發布時間：%@", publishTime];
	return time;
}

@synthesize description;
@synthesize publishTime;
@synthesize validBeginTime;
@synthesize validEndTime;
@synthesize wave;
@synthesize waveLevel;
@synthesize wind;
@synthesize windLevel;

@end
