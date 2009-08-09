//
//  TWNearSeaCell.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWNearSeaCell.h"


@interface TWNearSeaCell (ProtectedMethods)
- (void)draw:(CGRect)bounds;
@end

@interface TWNearSeaCellContentView : UIView
{
	TWNearSeaCell *_delegate;
}
@property (assign, nonatomic) TWNearSeaCell *delegate;
@end

@implementation TWNearSeaCellContentView

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

@implementation TWNearSeaCell

- (void)dealloc
{
	[_ourContentView removeFromSuperview];
	[_ourContentView release];
	
	[description release];
	[validBeginTime release];
	[validEndTime release];
	[wave release];
	[waveLevel release];
	[wind release];
	[windLevel release];
	
    [super dealloc];
}
- (void)_init
{
	if (!_ourContentView) {
		CGRect cellFrame = CGRectMake(10, 10, 280, 300);
		_ourContentView = [[TWNearSeaCellContentView alloc] initWithFrame:cellFrame];
		_ourContentView.delegate = self;
		[self.contentView addSubview:_ourContentView];
	}
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
	[@"有效時間" drawInRect:CGRectMake(10, 10, 260, 30) withFont:[UIFont boldSystemFontOfSize:16.0]];
	NSString *valid = [NSString stringWithFormat:@"%@ - %@", validBeginTime, validEndTime];
	[valid drawInRect:CGRectMake(10, 35, 260, 30) withFont:[UIFont systemFontOfSize:14.0]];
	[description drawInRect:CGRectMake(10, 70, 260, 60) withFont:[UIFont boldSystemFontOfSize:20.0]];
	[wind drawInRect:CGRectMake(10, 180, 260, 30) withFont:[UIFont systemFontOfSize:16.0]];
	[windLevel drawInRect:CGRectMake(10, 204, 260, 30) withFont:[UIFont systemFontOfSize:16.0]];
	[wave drawInRect:CGRectMake(10, 240, 260, 30) withFont:[UIFont systemFontOfSize:16.0]];
	[waveLevel drawInRect:CGRectMake(10, 264, 260, 30) withFont:[UIFont systemFontOfSize:16.0]];
}
- (void)setNeedsDisplay
{
	[_ourContentView setNeedsDisplay];
	[super setNeedsDisplay];
}

@synthesize description;
@synthesize validBeginTime;
@synthesize validEndTime;
@synthesize wave;
@synthesize waveLevel;
@synthesize wind;
@synthesize windLevel;

@end
