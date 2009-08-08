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
	NSMutableDictionary *dictionary = [[self arrayForTableView:tableView] objectAtIndex:indexPath.row];
	tableView.userInteractionEnabled = NO;
	[dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"isLoading"];
	[tableView reloadData];

	NSString *identifier = [dictionary objectForKey:@"identifier"];
	[[TWAPIBox sharedBox] fetchImageWithIdentifier:identifier delegate:self userInfo:dictionary];
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchImageData:(NSData *)data identifier:(NSString *)identifier userInfo:(id)userInfo
{
	[self resetLoading];
	
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
	[self pushErrorViewWithError:error];	
}

@end

