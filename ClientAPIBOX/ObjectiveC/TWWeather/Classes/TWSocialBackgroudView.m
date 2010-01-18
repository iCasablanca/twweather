//
// TWSocialBackgroudView.m
//
// Copyright (c) 2009 Weizhong Yang (http://zonble.net)
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

#import "TWSocialBackgroudView.h"

@implementation TWSocialBackgroudView

- (void)dealloc 
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat black[] = {0.0, 0.0, 0.0, 1.0};
	CGContextSetFillColor(context, black);
	CGContextFillRect(context, [self bounds]);
	CGFloat white[] = {1.0, 1.0, 1.0, 1.0};	
	
	CGFloat left = 10.0, top = 5.0, width = 300.0, height = 180.0;
	CGFloat radius = 10.0;
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, left, top + radius);
	CGPathAddArcToPoint(path, NULL, left, top, left + radius, top, radius);
	CGPathAddLineToPoint(path, NULL, left + width - radius, top);
	CGPathAddArcToPoint(path, NULL, left + width, top, left + width, top + radius, radius);
	CGPathAddLineToPoint(path, NULL, left + width, top + height - radius);
	CGPathAddArcToPoint(path, NULL, left + width, top + height, left + width - radius, top + height, radius);
	CGPathAddLineToPoint(path, NULL, left + radius, top + height);
	CGPathAddArcToPoint(path, NULL, left, top + height, left, top + height - radius, radius);	
	CGPathCloseSubpath(path);
	CGContextAddPath(context, path);	
	CGContextSetFillColor(context, white);
	CGContextFillPath(context);
	CGPathRelease(path);
}

@end
