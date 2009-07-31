//
//  TWWeekResultCell.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWWeekResultCell.h"


@interface TWWeekResultCell (ProtectedMethods)
- (void)draw:(CGRect)bounds;
@end

@interface TWWeekResultCellContentView : UIView
{
	TWWeekResultCell *_delegate;
}
@property (assign, nonatomic) TWWeekResultCell *delegate;
@end

@implementation TWWeekResultCellContentView

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

@implementation TWWeekResultCell

- (void)dealloc
{
	[_ourContentView removeFromSuperview];
	[_ourContentView release];
	[date release];
	[description release];
	[temperature release];
    [super dealloc];
}
- (void)_init
{
	CGRect cellFrame = CGRectMake(10, 1, 280, 50);
	_ourContentView = [[TWWeekResultCellContentView alloc] initWithFrame:cellFrame];
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
	[date drawInRect:CGRectMake(10, 2, 200, 15) withFont:[UIFont systemFontOfSize:14.0]];
	[description drawInRect:CGRectMake(10, 23, 200, 30) withFont:[UIFont boldSystemFontOfSize:18.0]];
	NSString *temperatureString = [NSString stringWithFormat:@"%@ ℃", temperature];
	[temperatureString drawInRect:CGRectMake(40, 23, 240, 15) withFont:[UIFont systemFontOfSize:12.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentRight];
}
- (void)setNeedsDisplay
{
	[_ourContentView setNeedsDisplay];
	[super setNeedsDisplay];
}

@synthesize date;
@synthesize description;
@synthesize temperature;

@end
