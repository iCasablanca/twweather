//
//  ZBGraphicsLIstTableViewCell.m
//  TWWeather
//
//  Created by zonble on 2009/1/14.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "ZBGraphicsListTableViewCell.h"

@implementation ZBGraphicsListTableViewCellContentView
- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.opaque = NO;
	}
	return self;
}
- (void)drawRect:(CGRect)rect
{
	NSString *title = _delegate.graphicTitle;
	UIImage *image = _delegate.graphicImage;
	
	CGRect imageFrame = CGRectMake(10, 10, 40, 40);
	if (image)
		[image drawInRect:imageFrame];
	
	if (_delegate.selected)
		[[UIColor whiteColor] set];
	else
		[[UIColor blackColor] set];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextStrokeRect(context, imageFrame);
	[title drawInRect:CGRectMake(60, 20, 240, 40) withFont:[UIFont boldSystemFontOfSize:18.0]];
}

@synthesize delegate = _delegate;
@end

@implementation ZBGraphicsListTableViewCell

- (void)dealloc 
{
	[_graphicTitle release];
	[_graphicImage release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		CGRect contentViewFrame = [self bounds];
		contentViewFrame.size.height = 60;
		contentViewFrame.size.width = 270;
		contentViewFrame.origin.x = 10;
		contentViewFrame.origin.y = 2;
		_graphicContentView = [[ZBGraphicsListTableViewCellContentView alloc] initWithFrame:contentViewFrame];
		_graphicContentView.delegate = self;
		[self addSubview:_graphicContentView];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	[_graphicContentView setNeedsDisplay];
}

@synthesize graphicTitle = _graphicTitle;
@synthesize graphicImage = _graphicImage;

@end
