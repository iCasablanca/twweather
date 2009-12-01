//
//  TWLoadingView.h
//  TWWeather
//
//  Created by zonble on 2009/08/08.
//

@interface TWLoadingView : UIView
{
	UIActivityIndicatorView *activityIndicator;
}

- (void)startAnimating;
- (void)stopAnimating;

@end
