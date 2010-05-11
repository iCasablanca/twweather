//
// TWForecastResultCell.m
//
// Copyright (c) 2009 - 2010 Weizhong Yang (http://zonble.net)
// All Rights Reserved
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of Weizhong Yang (zonble) nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY WEIZHONG YANG ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL WEIZHONG YANG BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "TWForecastResultCell.h"


@interface TWForecastResultCell (ProtectedMethods)
- (void)draw:(CGRect)bounds;
- (IBAction)copy:(id)sender;
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
	if (_delegate.selectionStyle != UITableViewCellSelectionStyleNone) {
		return;
	}
	if (touchBeginDate) {
		[touchBeginDate release];
	}
	touchBeginDate = [[NSDate date] retain];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (_delegate.selectionStyle != UITableViewCellSelectionStyleNone) {
		[super touchesEnded:touches withEvent:event];
	}	
	else if ( touchBeginDate && ([[NSDate date] timeIntervalSinceDate:touchBeginDate] > 1.0)) {	
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
		CGRect cellFrame = CGRectMake(10, 5, 280.0, 100.0);
		_ourContentView = [[TWForecastResultCellContentView alloc] initWithFrame:cellFrame];
		_ourContentView.backgroundColor = [UIColor whiteColor];
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
- (NSString *)_description
{
	NSMutableString *s = [NSMutableString string];
	[s appendFormat:@"%@\n", title];
	[s appendFormat:@"%@ - %@\n", beginTime, endTime];
	[s appendFormat:@"%@\n", description];
	[s appendFormat:@"溫度： %@ ℃\n", temperature];
	[s appendFormat:@"降雨機率： %@ %%", rain];
	return s;
}
- (NSString *)_shortDescription
{
	NSMutableString *s = [NSMutableString string];
	[s appendFormat:@"%@\n", title];
	[s appendFormat:@"%@\n", description];
	[s appendFormat:@"溫度： %@ ℃\n", temperature];
	[s appendFormat:@"降雨機率： %@ %%", rain];
	return s;
}

- (void)draw:(CGRect)bounds
{	
	CGSize size = weatherImage.size;
	[weatherImage drawInRect:CGRectMake(0, -5, size.width * 0.75, size.height * 0.75)];
	
	if (self.highlighted || self.selected) {
		[[UIColor whiteColor] set];
	}
	else {
		[[UIColor blackColor] set];
	}
		
	[title drawInRect:CGRectMake(140, 5, 100, 20) withFont:[UIFont boldSystemFontOfSize:14.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentLeft];
	NSString *timeString = [NSString stringWithFormat:@"%@\n%@", beginTime, endTime];
	[timeString drawInRect:CGRectMake(140, 26, 160, 40) withFont:[UIFont systemFontOfSize:10.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentLeft];

	[description drawInRect:CGRectMake(10, 80, 100, 60) withFont:[UIFont systemFontOfSize:12.0] lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter];	
	NSString *temperatureString = [NSString stringWithFormat:@"%@ ℃", temperature];
	[temperatureString drawInRect:CGRectMake(140, 56, 100, 20) withFont:[UIFont boldSystemFontOfSize:18.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentLeft];
	NSString *rainString = [NSString stringWithFormat:@"降雨機率： %@ %%", rain];
	[rainString drawInRect:CGRectMake(140, 80, 100, 20) withFont:[UIFont systemFontOfSize:12.0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentLeft];
	
}
- (IBAction)copy:(id)sender
{
	UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
	[pasteBoard setString:[self _description]];
}

- (void)setNeedsDisplay
{
	[_ourContentView setNeedsDisplay];
	[super setNeedsDisplay];
}

- (BOOL)isAccessibilityElement
{
	return YES;
}

- (NSString *)accessibilityLabel
{
	return [self _shortDescription];
}

- (NSString *)accessibilityValue
{
	return [NSString stringWithFormat:@"%@ - %@\n", beginTime, endTime];
}

- (UIAccessibilityTraits)accessibilityTraits
{
	return UIAccessibilityTraitNone;
}


@synthesize title;
@synthesize description;
@synthesize rain;
@synthesize temperature;
@synthesize beginTime;
@synthesize endTime;
@synthesize weatherImage;

@end
