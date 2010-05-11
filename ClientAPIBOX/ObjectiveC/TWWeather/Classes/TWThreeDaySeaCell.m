//
// TWThreeDaySeaCell.m
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

#import "TWThreeDaySeaCell.h"

@interface TWThreeDaySeaCell (ProtectedMethods)
- (void)draw:(CGRect)bounds;
- (IBAction)copy:(id)sender;
@end

@interface TWThreeDaySeaCellContentView : UIView
{
	TWThreeDaySeaCell *_delegate;
	NSDate *touchBeginDate;
}
@property (assign, nonatomic) TWThreeDaySeaCell *delegate;
@end

@implementation TWThreeDaySeaCellContentView

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

@implementation TWThreeDaySeaCell

- (void)dealloc
{
	[_ourContentView removeFromSuperview];
	[_ourContentView release];
	
	[date release];
	[description release];
	[wind release];
	[windScale release];
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

- (void)draw:(CGRect)bounds
{
	[date drawInRect:CGRectMake(10, 5, 260, 20) withFont:[UIFont boldSystemFontOfSize:14.0]];
	[description drawInRect:CGRectMake(10, 27, 260, 30) withFont:[UIFont boldSystemFontOfSize:18.0]];
	[wind drawInRect:CGRectMake(10, 55, 260, 20) withFont:[UIFont systemFontOfSize:12.0]];
	[windScale drawInRect:CGRectMake(10, 75, 260, 20) withFont:[UIFont systemFontOfSize:12.0]];
	[wave drawInRect:CGRectMake(10, 95, 260, 20) withFont:[UIFont systemFontOfSize:12.0]];
	
	CGSize size = weatherImage.size;
	[weatherImage drawInRect:CGRectMake(180, 20, size.width * 0.6, size.height * 0.6)];
}
- (NSString *)_desciption
{
	NSMutableString *s = [NSMutableString string];
	[s appendFormat:@"%@\n", date];
	[s appendFormat:@"%@\n", description];
	[s appendFormat:@"%@\n", wind];
	[s appendFormat:@"%@\n", windScale];
	[s appendFormat:@"%@", wave];
	return s;
}
- (IBAction)copy:(id)sender
{
	UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
	[pasteBoard setString:[self _desciption]];
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
	return UIAccessibilityTraitNone;
}


@synthesize date;
@synthesize description;
@synthesize wind;
@synthesize windScale;
@synthesize wave;
@synthesize weatherImage;

@end
