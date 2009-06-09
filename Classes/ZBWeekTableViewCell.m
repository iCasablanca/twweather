//
//  ZBWeekTableViewCell.m
//  TWWeather
//
//  Created by zonble on 2009/1/18.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "ZBWeekTableViewCell.h"

@implementation ZBWeekTableViewCellContentView

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.opaque = NO;
	}
	return self;
}
- (void)drawRect:(CGRect)rect
{
	[[UIColor blackColor] set];
	NSString *date = _delegate.date;		
	[date drawInRect:CGRectMake(90, 5, 200, 16) withFont:[UIFont boldSystemFontOfSize:18.0]];
	
	NSString *description = _delegate.description;
	[description drawInRect:CGRectMake(90, 28, 200, 40) withFont:[UIFont boldSystemFontOfSize:16.0]];
	
	NSString *temperature = [_delegate.temperature stringByAppendingString:[NSString stringWithUTF8String:"℃"]];
	[temperature drawInRect:CGRectMake(90, 28, 200, 40) withFont:[UIFont boldSystemFontOfSize:16.0] lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentRight];
		
	UIImage *image = _delegate.forecastImage;
	NSLog(@"image:%@",[image description]);
	[image drawInRect:CGRectMake(10, 0, 80, 50)];	
}

@synthesize delegate = _delegate;

@end

@implementation ZBWeekTableViewCell

- (void)dealloc 
{
	[_date release];
	[_temperature release];
	[_description release];
	[_forecastImage release];
	[_forecastContentView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		CGRect contentFrame = self.bounds;
		contentFrame.size.height = 50;
		contentFrame.origin.y += 2;
		_forecastContentView = [[ZBWeekTableViewCellContentView alloc] initWithFrame:contentFrame];
		_forecastContentView.delegate = self;
		[self addSubview:_forecastContentView];
    }
    return self;
}

- (void)setImageByCondition
{	
	NSMutableString *string = [NSMutableString stringWithString:@"Day"];
	
	if ([_description isEqualToString:[NSString stringWithUTF8String:"晴"]])
		[string appendString:@"Sunny"];
	else if ([_description isEqualToString:[NSString stringWithUTF8String:"晴天"]])
		[string appendString:@"Sunny"];
	else if ([_description isEqualToString:[NSString stringWithUTF8String:"陰"]])
		[string appendString:@"Glommy"];
	else if ([_description isEqualToString:[NSString stringWithUTF8String:"陰天"]])
		[string appendString:@"Glommy"];
	else if ([_description isEqualToString:[NSString stringWithUTF8String:"晴時多雲"]])
		[string appendString:@"SunnyCloudy"];
	else if ([_description isEqualToString:[NSString stringWithUTF8String:"多雲時晴"]])
		[string appendString:@"CloudySunny"];
	else if ([_description isEqualToString:[NSString stringWithUTF8String:"多雲"]])
		[string appendString:@"Cloudy"];
	else if ([_description isEqualToString:[NSString stringWithUTF8String:"多雲時陰"]])
		[string appendString:@"CloudyGlommy"];
	else if ([_description isEqualToString:[NSString stringWithUTF8String:"多雲短暫雨"]])
		[string appendString:@"GloomyRainy"];
	else
		[string appendString:@"Rainy"];
	[string appendString:@".png"];
	
	id tmp = _forecastImage;
	_forecastImage = [UIImage imageNamed:string];
	[_forecastImage retain];
	[tmp release];
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	[_forecastContentView setNeedsDisplay];
}

@synthesize date = _date;
@synthesize temperature = _temperature;
@synthesize description = _description;
@synthesize forecastImage = _forecastImage;

@end
