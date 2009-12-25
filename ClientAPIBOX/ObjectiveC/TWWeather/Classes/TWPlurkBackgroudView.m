//
//  TWPlurkBackgroudView.m
//  TWWeather
//
//  Created by zonble on 12/26/09.
//  Copyright 2009 Lithoglyph Inc.. All rights reserved.
//

#import "TWPlurkBackgroudView.h"

@implementation TWPlurkBackgroudView

- (void)dealloc 
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat black[] = {0.0, 0.0, 0.0, 1.0};
	CGContextSetFillColor(context, black);
	CGContextFillRect(context, [self bounds]);
	CGFloat white[] = {1.0, 1.0, 1.0, 1.0};	
	
	CGFloat left = 10.0, top = 5.0, width = 300.0, height = 180.0;
	CGFloat radius = 10.0;
	
	CGMutablePathRef path = CGPathCreateMutable();
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
	CGContextSetFillColor(context, white);
	CGContextFillPath(context);
	CGPathRelease(path);
}


@end
