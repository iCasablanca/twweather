//
//  TWThreeDaySeaCell.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWThreeDaySeaCell.h"

@interface TWThreeDaySeaCell (ProtectedMethods)
- (void)draw:(CGRect)bounds;
@end

@interface TWThreeDaySeaCellContentView : UIView
{
	TWThreeDaySeaCell *_delegate;
}
@property (assign, nonatomic) TWThreeDaySeaCell *delegate;
@end

@implementation TWThreeDaySeaCellContentView

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

@implementation TWThreeDaySeaCell

- (void)dealloc
{
	[_ourContentView removeFromSuperview];
	[_ourContentView release];
	
	[date release];
	[description release];
	[wind release];
	[windLevel release];
	[wave release];
	[weatherImage release];
	
    [super dealloc];
}
- (void)_init
{
	if (!_ourContentView) {
		CGRect cellFrame = CGRectMake(10, 1, 280, 110);
		_ourContentView = [[TWThreeDaySeaCellContentView alloc] initWithFrame:cellFrame];
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
	[date drawInRect:CGRectMake(10, 5, 260, 20) withFont:[UIFont boldSystemFontOfSize:14.0]];
	[description drawInRect:CGRectMake(10, 27, 260, 30) withFont:[UIFont boldSystemFontOfSize:18.0]];
	[wind drawInRect:CGRectMake(10, 55, 260, 20) withFont:[UIFont systemFontOfSize:14.0]];
	[windLevel drawInRect:CGRectMake(10, 75, 260, 20) withFont:[UIFont systemFontOfSize:14.0]];
	[wave drawInRect:CGRectMake(10, 95, 260, 20) withFont:[UIFont systemFontOfSize:14.0]];
	
	CGSize size = weatherImage.size;
	[weatherImage drawInRect:CGRectMake(220, 20, size.width * 0.8, size.height * 0.8)];
}
- (void)setNeedsDisplay
{
	[_ourContentView setNeedsDisplay];
	[super setNeedsDisplay];
}


@synthesize date;
@synthesize description;
@synthesize wind;
@synthesize windLevel;
@synthesize wave;
@synthesize weatherImage;

@end
