//
//  TWLoadingView.m
//  TWWeather
//
//  Created by zonble on 2009/08/08.
//

#import "TWLoadingView.h"


@implementation TWLoadingView

- (void)dealloc
{
	[activityIndicator release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		CGFloat x = (frame.size.width - 40) / 2;
		CGFloat y = (frame.size.height - 40) / 2;
		CGRect rect = CGRectMake(x, y, 40, 40);
		activityIndicator.frame = rect;
		[self addSubview:activityIndicator];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();	
	CGRect selfRect = [self bounds];
	CGMutablePathRef path = CGPathCreateMutable();
	CGFloat radius = 10;
	
	CGFloat left = selfRect.origin.x + 10, top = selfRect.origin.y + 10, width = selfRect.size.width - 20, height = selfRect.size.height - 20;
	
	CGPathMoveToPoint(path, NULL, left, top + radius);
	CGPathAddArcToPoint(path, NULL, left, top, left + radius, top, radius);
	CGPathAddLineToPoint(path, NULL, left + width - radius, top);
	CGPathAddArcToPoint(path, NULL, left + width, top, left + width, top + radius, radius);
	CGPathAddLineToPoint(path, NULL, left + width, top + height - radius);
	CGPathAddArcToPoint(path, NULL, left + width, top + height, left + width - radius, top + height, radius);
	CGPathAddLineToPoint(path, NULL, left + radius, top + height);
	CGPathAddArcToPoint(path, NULL, left, top + height, left, top + height - radius, radius);	
	CGPathCloseSubpath(path);
	CGContextAddPath(context, path);
	
	CGFloat black[] = {0.0, 0.0, 0.0, 0.7};
	CGContextSetFillColor(context, black);
	CGContextFillPath(context);
	CGPathRelease(path);
}

- (void)startAnimating
{
	[activityIndicator startAnimating];
}
- (void)stopAnimating
{
	[activityIndicator stopAnimating];
}


@end
