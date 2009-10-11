//
//  TWTideCell.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWTideCell.h"


@interface TWTideCell (ProtectedMethods)
- (void)draw:(CGRect)bounds;
- (IBAction)copy:(id)sender;
@end

@interface TWTideCellContentView : UIView
{
	TWTideCell *_delegate;
	NSDate *touchBeginDate;
}
@property (assign, nonatomic) TWTideCell *delegate;
@end

@implementation TWTideCellContentView

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

@implementation TWTideCell

- (void)dealloc
{
	[_ourContentView removeFromSuperview];
	[_ourContentView release];
	
	[dateString release];
	[lunarDateString release];
	
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
- (IBAction)copy:(id)sender
{
	NSMutableString *s = [NSMutableString string];
	[s appendFormat:@"%@\n", dateString];
	[s appendFormat:@"%@\n", lunarDateString];
	for (NSDictionary *tide in tides) {
		NSString *name = [tide objectForKey:@"name"];
		NSString *shortTime = [tide objectForKey:@"shortTime"];
		NSString *height = [tide objectForKey:@"height"];
		[s appendFormat:@"%@ %@ %@\n", name, shortTime, height];
	}
	UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
	[pasteBoard setString:s];
}
- (void)setNeedsDisplay
{
	[_ourContentView setNeedsDisplay];
	[super setNeedsDisplay];
}


@synthesize dateString;
@synthesize lunarDateString;

@synthesize tides;

@end
