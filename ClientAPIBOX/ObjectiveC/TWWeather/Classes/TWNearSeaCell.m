//
// TWNearSeaCell.m
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
- (NSString *)_description
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
	return s;
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
	return [self _description];
}

- (UIAccessibilityTraits)accessibilityTraits
{
	return UIAccessibilityTraitUpdatesFrequently;
}

@synthesize description;
@synthesize validBeginTime;
@synthesize validEndTime;
@synthesize wave;
@synthesize waveLevel;
@synthesize wind;
@synthesize windScale;

@end
