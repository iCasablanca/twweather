//
//  TWNearSeaCell.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWNearSeaCell.h"


@interface TWNearSeaCell (ProtectedMethods)
- (void)draw:(CGRect)bounds;
- (IBAction)copy:(id)sender;
@end

@interface TWNearSeaCellContentView : UIView
{
	TWNearSeaCell *_delegate;
	NSDate *touchBeginDate;
}
@property (assign, nonatomic) TWNearSeaCell *delegate;
@end

@implementation TWNearSeaCellContentView

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
	[windScale release];
	
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
- (void)draw:(CGRect)bounds
{
	[@"有效時間" drawInRect:CGRectMake(10, 10, 260, 30) withFont:[UIFont boldSystemFontOfSize:16.0]];
	NSString *valid = [NSString stringWithFormat:@"%@ - %@", validBeginTime, validEndTime];
	[valid drawInRect:CGRectMake(10, 35, 260, 30) withFont:[UIFont systemFontOfSize:14.0]];
	[description drawInRect:CGRectMake(10, 64, 260, 60) withFont:[UIFont boldSystemFontOfSize:20.0]];
	[wind drawInRect:CGRectMake(10, 210, 260, 30) withFont:[UIFont systemFontOfSize:14.0]];
	[windScale drawInRect:CGRectMake(10, 230, 260, 30) withFont:[UIFont systemFontOfSize:14.0]];
	[wave drawInRect:CGRectMake(10, 250, 260, 30) withFont:[UIFont systemFontOfSize:14.0]];
	[waveLevel drawInRect:CGRectMake(10, 270, 260, 30) withFont:[UIFont systemFontOfSize:14.0]];
}
- (IBAction)copy:(id)sender
{
	NSMutableString *s = [NSMutableString string];
	[s appendFormat:@"%@\n", @"有效時間"];
	NSString *valid = [NSString stringWithFormat:@"%@ - %@", validBeginTime, validEndTime];
	[s appendFormat:@"%@\n", valid];
	[s appendFormat:@"%@\n", description];
	[s appendFormat:@"%@\n", wind];
	[s appendFormat:@"%@\n", windScale];
	[s appendFormat:@"%@\n", wave];
	[s appendFormat:@"%@", waveLevel];
	UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
	[pasteBoard setString:s];
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
@synthesize windScale;

@end
