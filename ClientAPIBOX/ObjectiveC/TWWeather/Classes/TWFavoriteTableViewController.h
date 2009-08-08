//
//  TWFavoriteTableViewController.h
//  TWWeather
//
//  Created by zonble on 2009/08/07.
//

#import <UIKit/UIKit.h>
#import "TWLocationSettingTableViewController.h"
#import "TWLoadingView.h"

@interface TWFavoriteTableViewController : UITableViewController <TWLocationSettingTableViewControllerDelegate>
{
	NSMutableArray *_filterArray;
	NSMutableArray *_filteredArray;
	NSMutableArray *_favArray;
	
	TWLoadingView *loadingView;
	UITableView *_tableView;
	UILabel *errorLabel;
	
	BOOL isLoading;
}

- (void)updateFilteredArray;
- (void)loadData;
- (void)showLoadingView;
- (void)hideLoadingView;

- (IBAction)changeSetting:(id)sender;
- (IBAction)reload:(id)sender;

@property (retain, nonatomic) UITableView *tableView;

@end
