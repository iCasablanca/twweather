//
//  TWImageTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWImageTableViewController.h"
#import "TWImageViewController.h"

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
	self.tableView.userInteractionEnabled = NO;
	[dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isLoading"];
	[self.tableView reloadData];

	NSString *identifier = [dictionary objectForKey:@"identifier"];
	[[TWAPIBox sharedBox] fetchImageWithLocationIdentifier:identifier delegate:self userInfo:dictionary];
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchImageData:(NSData *)data identifier:(NSString *)identifier userInfo:(id)userInfo
{
	[self resetLoading];
	self.tableView.userInteractionEnabled = YES;
	
	NSDictionary *dictionary = (NSDictionary *)userInfo;
	NSString *name = [dictionary objectForKey:@"name"];
	
	TWImageViewController *controller = [[TWImageViewController alloc] init];
	controller.title = name;
	UIImage *image = [UIImage imageWithData:data];
	controller.image = image;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];

}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchImageWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	[self resetLoading];
	self.tableView.userInteractionEnabled = YES;
	[self pushErrorViewWithError:error];	
}

@end

