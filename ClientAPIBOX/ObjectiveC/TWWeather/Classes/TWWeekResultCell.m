//
//  TWWeekResultCell.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWWeekResultCell.h"


@interface TWWeekResultCell (ProtectedMethods)
- (void)draw:(CGRect)bounds;
- (IBAction)copy:(id)sender;
@end

@interface TWWeekResultCellContentView : UIView
{
	TWWeekResultCell *_delegate;
	NSDate *touchBeginDate;
}
@property (assign, nonatomic) TWWeekResultCell *delegate;
@end

@implementation TWWeekResultCellContentView

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
- (IBAction)copy:(id)sender
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
	if ( touchBeginDate && ([[NSDate date] timeIntervalSinceDate:touchBeginDate] > 1.0)) {	
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
	if (!_ourContentView) {
		CGRect cellFrame = CGRectMake(10, 1, 280, 50);
		_ourContentView = [[TWWeekResultCellContentView alloc] initWithFrame:cellFrame];
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
	[date drawInRect:CGRectMake(10, 2, 200, 15) withFont:[UIFont systemFontOfSize:14.0]];
	[description drawInRect:CGRectMake(10, 23, 200, 30) withFont:[UIFont boldSystemFontOfSize:18.0]];
	NSString *temperatureString = [NSString stringWithFormat:@"%@ ℃", temperature];
	[temperatureString drawInRect:CGRectMake(40, 23, 240, 15) withFont:[UIFont systemFontOfSize:12.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentRight];
}
- (IBAction)copy:(id)sender
{
	NSMutableString *s = [NSMutableString string];
	[s appendFormat:@"%@\n", date];
	[s appendFormat:@"%@\n", description];
	[s appendFormat:@"%@ ℃", temperature];
	UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
	[pasteBoard setString:s];
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
