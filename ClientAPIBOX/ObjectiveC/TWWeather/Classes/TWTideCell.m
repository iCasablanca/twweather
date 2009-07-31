//
//  TWTideCell.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWTideCell.h"


@interface TWTideCell (ProtectedMethods)
- (void)draw:(CGRect)bounds;
@end

@interface TWTideCellContentView : UIView
{
	TWTideCell *_delegate;
}
@property (assign, nonatomic) TWTideCell *delegate;
@end

@implementation TWTideCellContentView

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

@implementation TWTideCell

- (void)dealloc
{
	[_ourContentView removeFromSuperview];
	[_ourContentView release];
	
	[dateString release];
	[lunarDateString release];
	[lowShortTime release];
	[lowHeight release];
	[highshortTime release];
	[highHeight release];
	
	[super dealloc];
}
- (void)_init
{
	CGRect cellFrame = CGRectMake(10, 10, 280, 100);
	_ourContentView = [[TWTideCellContentView alloc] initWithFrame:cellFrame];
	_ourContentView.delegate = self;
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
	[dateString drawInRect:CGRectMake(10, 0, 260, 30) withFont:[UIFont boldSystemFontOfSize:20.0]];
	[lunarDateString drawInRect:CGRectMake(10, 6, 260, 30) withFont:[UIFont systemFontOfSize:14.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentRight];
	[@"乾潮" drawInRect:CGRectMake(10, 40, 100, 40) withFont:[UIFont boldSystemFontOfSize:20.0]];
	[lowShortTime drawInRect:CGRectMake(90, 44, 80, 20) withFont:[UIFont systemFontOfSize:16.0]];
	[[lowHeight stringByAppendingString:@"cm"] drawInRect:CGRectMake(160, 44, 80, 20) withFont:[UIFont systemFontOfSize:16.0]];
	[@"滿潮" drawInRect:CGRectMake(10, 70, 100, 40) withFont:[UIFont boldSystemFontOfSize:20.0]];
	[highshortTime drawInRect:CGRectMake(90, 74, 80, 20) withFont:[UIFont systemFontOfSize:16.0]];
	[[highHeight stringByAppendingString:@"cm"] drawInRect:CGRectMake(160, 74, 80, 20) withFont:[UIFont systemFontOfSize:16.0]];
}
- (void)setNeedsDisplay
{
	[_ourContentView setNeedsDisplay];
	[super setNeedsDisplay];
}


@synthesize dateString;
@synthesize lunarDateString;
@synthesize lowShortTime;
@synthesize lowHeight;
@synthesize highshortTime;
@synthesize highHeight;

@end
