//
//  TWFavoriteTableViewController.h
//  TWWeather
//
//  Created by zonble on 2009/08/07.
//

#import <UIKit/UIKit.h>
#import "TWLocationSettingTableViewController.h"

@interface TWFavoriteTableViewController : UITableViewController <TWLocationSettingTableViewControllerDelegate>
{
	NSMutableArray *_filterArray;
	NSMutableArray *_filteredArray;
	NSMutableArray *_favArray;
}

- (void)updateFilteredArray;

- (IBAction)changeSetting:(id)sender;

@end
