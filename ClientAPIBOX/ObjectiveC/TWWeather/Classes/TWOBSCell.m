//
//  TWOBSCell.m
//  TWWeather
//
//  Created by zonble on 2009/08/08.
//  Copyright 2009 Lithoglyph Inc.. All rights reserved.
//

#import "TWOBSCell.h"


@interface TWOBSCell (ProtectedMethods)
- (void)draw:(CGRect)bounds;
@end

@interface TWOBSCellContentView : UIView
{
	TWOBSCell *_delegate;
}
@property (assign, nonatomic) TWOBSCell *delegate;
@end

@implementation TWOBSCellContentView

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}
- (void)drawRect:(CGRect)rect
{
	[_delegate draw:self.bounds];
}

@synthesize delegate = _delegate;
@end

@implementation TWOBSCell

- (void)dealloc
{
	[_ourContentView removeFromSuperview];
	[_ourContentView release];
	[description release];
	[rain release];
	[temperature release];
//	[time release];
	[windDirection release];
	[windLevel release];
	[windStrongestLevel release];
    [super dealloc];
}
- (void)_init
{
	CGRect cellFrame = CGRectMake(10, 10, 280, 280);
	_ourContentView = [[TWOBSCellContentView alloc] initWithFrame:cellFrame];
	_ourContentView.delegate = self;
//	_ourContentView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self.contentView addSubview:_ourContentView];	
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
- (void)draw:(CGRect)bounds
{
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	[time drawInRect:CGRectMake(0, 0, 260, 20) withFont:[UIFont systemFontOfSize:16.0]];
	[@"天氣現象" drawInRect:CGRectMake(100, 30, 160, 20) withFont:[UIFont boldSystemFontOfSize:16.0]];
	[description drawInRect:CGRectMake(100, 70, 160, 80) withFont:[UIFont boldSystemFontOfSize:22.0]];
	
	[[NSString stringWithFormat:@"溫度: %@", temperature] drawInRect:CGRectMake(100, 130, 160, 20) withFont:[UIFont systemFontOfSize:18.0]];
	[[NSString stringWithFormat:@"累積雨量: %@ 毫米", rain] drawInRect:CGRectMake(100, 160, 160, 20) withFont:[UIFont systemFontOfSize:18.0]];
	[[NSString stringWithFormat:@"風向: %@", windDirection] drawInRect:CGRectMake(100, 190, 160, 20) withFont:[UIFont systemFontOfSize:18.0]];
	[[NSString stringWithFormat:@"風力: %@ 級", windLevel] drawInRect:CGRectMake(100, 220, 160, 20) withFont:[UIFont systemFontOfSize:18.0]];
	[[NSString stringWithFormat:@"陣風: %@ 級", windStrongestLevel] drawInRect:CGRectMake(100, 250, 260, 20) withFont:[UIFont systemFontOfSize:18.0]];
}
	
- (void)setNeedsDisplay
{
	[_ourContentView setNeedsDisplay];
	[super setNeedsDisplay];
}

@synthesize description;
@synthesize rain;
@synthesize temperature;
//@synthesize time;
@synthesize windDirection;
@synthesize windLevel;
@synthesize windStrongestLevel;

@end
