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

//	[lowShortTime release];
//	[lowHeight release];
//	[highshortTime release];
//	[highHeight release];
	
	[tides release];
	
	[super dealloc];
}
- (void)_init
{
	if (!_ourContentView) {
		CGRect cellFrame = CGRectMake(10, 10, 280, 100);
		_ourContentView = [[TWTideCellContentView alloc] initWithFrame:cellFrame];
		_ourContentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		_ourContentView.delegate = self;
		_ourContentView.backgroundColor = [UIColor clearColor];
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
- (void)draw:(CGRect)bounds
{
	[dateString drawInRect:CGRectMake(10, 0, 260, 30) withFont:[UIFont boldSystemFontOfSize:20.0]];
	[lunarDateString drawInRect:CGRectMake(10, 6, 260, 30) withFont:[UIFont systemFontOfSize:14.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentRight];
	NSUInteger i = 0;
	for (NSDictionary *tide in tides) {
		NSString *name = [tide objectForKey:@"name"];
		NSString *shortTime = [tide objectForKey:@"shortTime"];
		NSString *height = [tide objectForKey:@"height"];
		[name drawInRect:CGRectMake(10, 40.0 + 30 * i, 100, 40) withFont:[UIFont boldSystemFontOfSize:20.0]];
		[shortTime drawInRect:CGRectMake(90, 44 + 30 * i, 80, 20) withFont:[UIFont systemFontOfSize:16.0]];
		[[height stringByAppendingString:@"cm"] drawInRect:CGRectMake(160, 44 + 30 * i, 80, 20) withFont:[UIFont systemFontOfSize:16.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentRight];
		i++;
	}
}
- (void)setNeedsDisplay
{
	[_ourContentView setNeedsDisplay];
	[super setNeedsDisplay];
}


@synthesize dateString;
@synthesize lunarDateString;
//@synthesize lowShortTime;
//@synthesize lowHeight;
//@synthesize highshortTime;
//@synthesize highHeight;

@synthesize tides;

@end
