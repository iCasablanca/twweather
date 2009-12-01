//
//  TWLoadingCell.h
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

@class TWLoadingCellContentView;

@interface TWLoadingCell : UITableViewCell 
{
	UIActivityIndicatorView *activityIndicator;
}

- (void)startAnimating;
- (void)stopAnimating;

@end
