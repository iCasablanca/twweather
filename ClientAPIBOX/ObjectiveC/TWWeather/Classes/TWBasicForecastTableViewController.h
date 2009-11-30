//
//  TWBasicForecastTableViewController.h
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"

@interface TWBasicForecastTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
{
	NSMutableArray *_array;
	NSMutableArray *_filteredArray;
	UISearchBar *_searchBar;
	UISearchDisplayController *_searchController;
	BOOL _firstTimeVisiable;
	
	UITableViewStyle _style;
	UITableView *_tableView;
}

- (NSArray *)arrayForTableView:(UITableView *)tableView;
- (void)resetLoading;
- (void)pushErrorViewWithError:(NSError *)error;

@property (assign, nonatomic) NSArray *array;
@property (assign, nonatomic) UITableViewStyle style;
@property (retain, nonatomic) UITableView *tableView;

@end
