//
//  TWForecastResultCell.m
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import "TWForecastResultCell.h"


@interface TWForecastResultCell (ProtectedMethods)
- (void)draw:(CGRect)bounds;
- (void)copy:(id)sender;
@end

@interface TWForecastResultCellContentView : UIView
{
	TWForecastResultCell *_delegate;
	NSDate *touchBeginDate;
}
@property (assign, nonatomic) TWForecastResultCell *delegate;
@end

@implementation TWForecastResultCellContentView

- (void) dealloc
{
	[touchBeginDate release];
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
		touchBeginDate = nil;
	}
	return self;
}
- (void)drawRect:(CGRect)rect
{
	[_delegate draw:self.bounds];
}
- (BOOL)canBecomeFirstResponder
{
	return YES;
}
- (void)copy:(id)sender
{
	[_delegate copy:sender];	
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
	if (action == @selector(copy:)) {
		return YES;
	}
	return NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	if (touchBeginDate) {
		[touchBeginDate release];
	}
	touchBeginDate = [[NSDate date] retain];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ( touchBeginDate && ([[NSDate date] timeIntervalSinceDate:touchBeginDate] > 2.0)) {	
		[self becomeFirstResponder];
		[[UIMenuController sharedMenuController] update];
		[[UIMenuController sharedMenuController] setTargetRect:CGRectMake(0, 0, 100, 100) inView:self];
		[[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
	}
	else {
		[super touchesEnded:touches withEvent:event];
	}
	[touchBeginDate release];
	touchBeginDate = nil;
}


@synthesize delegate = _delegate;
@end

@implementation TWForecastResultCell

- (void)dealloc
{
	[_ourContentView removeFromSuperview];
	[_ourContentView release];
	[title release];
	[description release];
	[rain release];
	[temperature release];
	[beginTime release];
	[endTime release];
	[weatherImage release];
    [super dealloc];
}
- (void)_init
{
	if (!_ourContentView) {
		CGRect cellFrame = CGRectMake(10, 5, 280.0, 110.0);
		_ourContentView.backgroundColor = [UIColor redColor];
		_ourContentView = [[TWForecastResultCellContentView alloc] initWithFrame:cellFrame];
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
- (void)draw:(CGRect)bounds
{
	if (self.highlighted || self.selected) {
		[[UIColor whiteColor] set];
	}
	else {
		[[UIColor blackColor] set];
	}
	
	[title drawInRect:CGRectMake(70, 5, 210, 20) withFont:[UIFont systemFontOfSize:14.0]];
	NSString *timeString = [NSString stringWithFormat:@"%@ - %@", beginTime, endTime];
	[timeString drawInRect:CGRectMake(70, 25, 210, 20) withFont:[UIFont systemFontOfSize:10.0]];
	[description drawInRect:CGRectMake(70, 42, 210, 30) withFont:[UIFont boldSystemFontOfSize:22.0]];
	NSString *temperatureString = [NSString stringWithFormat:@"溫度： %@ ℃", temperature];
	[temperatureString drawInRect:CGRectMake(70, 74, 210, 20) withFont:[UIFont systemFontOfSize:14.0]];
	NSString *rainString = [NSString stringWithFormat:@"降雨機率： %@ %%", rain];
	[rainString drawInRect:CGRectMake(70, 94, 210, 20) withFont:[UIFont systemFontOfSize:14.0]];
	
	CGSize size = weatherImage.size;
	[weatherImage drawInRect:CGRectMake(0, 40, size.width * 0.8, size.height * 0.8)];
}
- (void)copy:(id)sender
{
	NSMutableString *s = [NSMutableString string];
	[s appendFormat:@"%@\n", title];
	[s appendFormat:@"%@ - %@\n", beginTime, endTime];
	[s appendFormat:@"%@\n", description];
	[s appendFormat:@"溫度： %@ ℃\n", temperature];
	[s appendFormat:@"降雨機率： %@ %%", rain];
	UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
	[pasteBoard setString:s];
}

- (void)setNeedsDisplay
{
	[_ourContentView setNeedsDisplay];
	[super setNeedsDisplay];
}

@synthesize title;
@synthesize description;
@synthesize rain;
@synthesize temperature;
@synthesize beginTime;
@synthesize endTime;
@synthesize weatherImage;

@end
