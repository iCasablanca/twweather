//
//  TWBasicForecastTableViewController.h
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import <UIKit/UIKit.h>
#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"

@interface TWBasicForecastTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
{
	NSMutableArray *_array;
	NSMutableArray *_filteredArray;
	UISearchBar *_searchBar;
	UISearchDisplayController *_searchController;
	BOOL _firstTimeVisiable;
}

- (NSArray *)arrayForTableView:(UITableView *)tableView;
- (void)resetLoading;
- (void)pushErrorViewWithError:(NSError *)error;

@property (assign, nonatomic) NSArray *array;

@end
