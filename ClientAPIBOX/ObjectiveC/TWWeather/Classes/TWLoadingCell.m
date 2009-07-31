//
//  TWLoadingCell.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWLoadingCell.h"

@implementation TWLoadingCell

- (void)dealloc
{
	[activityIndicator release];
    [super dealloc];
}
- (void)_init
{
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(260, 12, 20, 20);
	[self addSubview:activityIndicator];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self _init];
    }
    return self;
	
}
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		[self _init];
    }
    return self;
}
- (void)startAnimating
{
	activityIndicator.hidden = NO;
	[activityIndicator startAnimating];
}
- (void)stopAnimating
{
	activityIndicator.hidden = YES;
	if ([activityIndicator isAnimating]) {
		[activityIndicator stopAnimating];
	}
}



@end
