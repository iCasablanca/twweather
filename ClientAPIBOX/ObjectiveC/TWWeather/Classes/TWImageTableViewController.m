//
//  TWImageTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWImageTableViewController.h"


@implementation TWImageTableViewController

- (void)viewDidLoad 
{
	[super viewDidLoad];
	self.array = [[TWAPIBox sharedBox] imageIdentifiers];
	self.title = @"天氣觀測雲圖";
}

#pragma mark UITableViewDataSource and UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSMutableDictionary *dictionary = [[self array] objectAtIndex:indexPath.row];
	NSString *identifier = [dictionary objectForKey:@"identifier"];
	[[TWAPIBox sharedBox] fetchImageWithLocationIdentifier:identifier delegate:self userInfo:dictionary];
	self.tableView.userInteractionEnabled = NO;
	[dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isLoading"];
	[self.tableView reloadData];
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchImageData:(NSData *)data identifier:(NSString *)identifier userInfo:(id)userInfo
{
	[self resetLoading];
	self.tableView.userInteractionEnabled = YES;
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchImageWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	[self resetLoading];
	self.tableView.userInteractionEnabled = YES;
	[self pushErrorViewWithError:error];	
}

@end

