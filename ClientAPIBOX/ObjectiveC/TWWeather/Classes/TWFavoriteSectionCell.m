//
// TWFavoriteSectionCell.m
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


#import "TWFavoriteSectionCell.h"

@interface TWFavoriteSectionCell (ProtectedMethods)
- (void)drawBackground:(CGRect)bounds;
@end

@interface TWFavoriteSectionCellBackgroundView : UIView
{
	TWFavoriteSectionCell *_delegate;
}
@property (assign, nonatomic) TWFavoriteSectionCell *delegate;
@end

@implementation TWFavoriteSectionCellBackgroundView

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.opaque = YES;
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}
- (void)drawRect:(CGRect)rect
{
	[_delegate drawBackground:self.bounds];
}

@synthesize delegate = _delegate;
@end

@implementation TWFavoriteSectionCell

- (void)dealloc
{
	[super dealloc];
}
- (void)_init
{
	self.textLabel.backgroundColor = [UIColor clearColor];
	self.textLabel.textColor = [UIColor whiteColor];
	self.textLabel.shadowColor = [UIColor darkGrayColor];
	self.textLabel.shadowOffset = CGSizeMake(0, -1);
	
	CGRect cellFrame = self.contentView.bounds;
	TWFavoriteSectionCellBackgroundView *ourBackgroundView = [[TWFavoriteSectionCellBackgroundView alloc] initWithFrame:cellFrame];
	ourBackgroundView.delegate = self;
	ourBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.backgroundView = [ourBackgroundView autorelease];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
		[self _init];
		self.detailTextLabel.text = [NSString stringWithUTF8String:"一週預報 "];
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.shadowColor = [UIColor darkGrayColor];
		self.detailTextLabel.shadowOffset = CGSizeMake(0, -1);
		self.detailTextLabel.font = [UIFont boldSystemFontOfSize:16.0];
		self.detailTextLabel.textColor = [UIColor whiteColor];
		self.loading = NO;
	}
	return self;
}
- (void)drawBackground:(CGRect)bounds
{	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGFloat radius = 10.0;

	CGContextSaveGState(context);
	CGContextMoveToPoint(context, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
	CGContextAddLineToPoint(context, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
	CGContextAddLineToPoint(context, CGRectGetMaxX(bounds), CGRectGetMinY(bounds) + radius);
	CGContextAddArcToPoint(context, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds) - radius, CGRectGetMinY(bounds), radius);	
	CGContextAddLineToPoint(context, CGRectGetMinX(bounds) + radius, CGRectGetMinY(bounds));
	CGContextAddArcToPoint(context, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMinX(bounds), CGRectGetMinY(bounds) + radius, radius);
	CGContextClosePath(context);
	CGContextClip(context);
	
	CGFloat gradient1Color[8] = {0.69, 0.74, 0.80, 1.00, 0.58, 0.64, 0.73, 1.00};
	CGGradientRef gradient1 = CGGradientCreateWithColorComponents(space, gradient1Color, NULL, 2);
	CGContextDrawLinearGradient(context, gradient1, CGPointMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds)), CGPointMake(CGRectGetMinX(bounds), bounds.origin.y + bounds.size.height / 2), kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient1);

	CGFloat gradient2Color[8] = {0.55, 0.62, 0.71, 1.00, 0.43, 0.52, 0.64, 1.00};
	CGGradientRef gradient2 = CGGradientCreateWithColorComponents(space, gradient2Color, NULL, 2);
	CGContextDrawLinearGradient(context, gradient2, CGPointMake(CGRectGetMinX(bounds), bounds.origin.y + bounds.size.height / 2), CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds)), kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient2);
	
	CGMutablePathRef path = CGPathCreateMutable();

	CGPathMoveToPoint(path, NULL, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
	CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(bounds), CGRectGetMinY(bounds) + radius);
	CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds) - radius, CGRectGetMinY(bounds), radius);	
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(bounds) + radius, CGRectGetMinY(bounds));
	CGPathAddArcToPoint(path, NULL, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMinX(bounds), CGRectGetMinY(bounds) + radius, radius);
	CGPathAddLineToPoint(path, NULL, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
	CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
	CGContextAddPath(context, path);
	[[UIColor grayColor] setStroke];	
	CGContextStrokePath(context);
	CGPathRelease(path);
	
}
- (void)setNeedsDisplay
{
	[super setNeedsDisplay];
	[self.backgroundView setNeedsDisplay];
}


#pragma mark -

- (void)setLoading:(BOOL)flag
{
	loading = flag;
	if (flag) {
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		view.frame = CGRectMake(0, 0, 15, 15);
		[view startAnimating];
		self.accessoryView = view;
		[view release];
	}
	else {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
		label.text = [NSString stringWithUTF8String:"➲"];
		label.font = [UIFont boldSystemFontOfSize:15.0];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		self.accessoryView = label;
		[label release];
	}
}

- (BOOL)isLoading
{
	return loading;
}

@dynamic loading;

@end
