//
//  TWLoadingView.h
//  TWWeather
//
//  Created by zonble on 2009/08/08.
//

#import <UIKit/UIKit.h>


@interface TWLoadingView : UIView
{
	UIActivityIndicatorView *activityIndicator;
}

- (void)startAnimating;
- (void)stopAnimating;

@end
