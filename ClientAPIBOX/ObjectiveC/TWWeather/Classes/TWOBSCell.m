//
// TWOBSCell.m
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

#import "TWOBSCell.h"


@interface TWOBSCell (ProtectedMethods)
- (void)draw:(CGRect)bounds;
- (IBAction)copy:(id)sender;
@end

@interface TWOBSCellContentView : UIView
{
	TWOBSCell *_delegate;
	NSDate *touchBeginDate;
}
@property (assign, nonatomic) TWOBSCell *delegate;
@end

@implementation TWOBSCellContentView

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

@implementation TWOBSCell

- (void)dealloc
{
	[_ourContentView removeFromSuperview];
	[_ourContentView release];
	[description release];
	[rain release];
	[temperature release];
	[windDirection release];
	[windScale release];
	[gustWindScale release];
	[weatherImage release];
    [super dealloc];
}
- (void)_init
{
	if (!_ourContentView) {
		CGRect cellFrame = CGRectMake(10, 10, 280, 290);
		_ourContentView = [[TWOBSCellContentView alloc] initWithFrame:cellFrame];
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
	[s appendFormat:@"%@\n", @"天氣現象"];
	[s appendFormat:@"%@\n", description];
	[s appendFormat:@"溫度: %@\n", temperature];
	[s appendFormat:@"累積雨量: %@ 毫米\n", rain];
	[s appendFormat:@"風向: %@\n", windDirection];
	[s appendFormat:@"風力: %@ 級\n", windScale];
	[s appendFormat:@"陣風: %@ 級\n", gustWindScale];
	return s;
}
- (void)draw:(CGRect)bounds
{
	CGSize size = weatherImage.size;
	[weatherImage drawInRect:CGRectMake(10, 0, size.width * 0.8, size.height * 0.8)];
	
	[@"天氣現象" drawInRect:CGRectMake(100, 90, 160, 20) withFont:[UIFont boldSystemFontOfSize:16.0]];
	[description drawInRect:CGRectMake(100, 140, 160, 80) withFont:[UIFont boldSystemFontOfSize:22.0]];
	
	[[NSString stringWithFormat:@"溫度: %@", temperature] drawInRect:CGRectMake(100, 190, 160, 20) withFont:[UIFont systemFontOfSize:14.0]];
	[[NSString stringWithFormat:@"累積雨量: %@ 毫米", rain] drawInRect:CGRectMake(100, 210, 160, 20) withFont:[UIFont systemFontOfSize:14.0]];
	[[NSString stringWithFormat:@"風向: %@", windDirection] drawInRect:CGRectMake(100, 230, 160, 20) withFont:[UIFont systemFontOfSize:14.0]];
	[[NSString stringWithFormat:@"風力: %@ 級", windScale] drawInRect:CGRectMake(100, 250, 160, 20) withFont:[UIFont systemFontOfSize:14.0]];
	[[NSString stringWithFormat:@"陣風: %@ 級", gustWindScale] drawInRect:CGRectMake(100, 270, 260, 20) withFont:[UIFont systemFontOfSize:14.0]];
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
@synthesize rain;
@synthesize temperature;
@synthesize windDirection;
@synthesize windScale;
@synthesize gustWindScale;
@synthesize weatherImage;

@end
