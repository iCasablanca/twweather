//
//  TWLocationSettingTableViewController.h
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import <UIKit/UIKit.h>


@class TWLocationSettingTableViewController;

@protocol TWLocationSettingTableViewControllerDelegate <NSObject>
@required
- (void)settingController:(TWLocationSettingTableViewController *)controller didUpdateFilter:(NSArray *)filterArray;
@end

@interface TWLocationSettingTableViewController : UITableViewController 
{
	id<TWLocationSettingTableViewControllerDelegate> delegate;
	NSMutableArray *_filterArray;
}

- (void)setFilter:(NSArray *)filter;
- (IBAction)donelAction:(id)sender;

@property (assign, nonatomic) id<TWLocationSettingTableViewControllerDelegate> delegate;

@end
