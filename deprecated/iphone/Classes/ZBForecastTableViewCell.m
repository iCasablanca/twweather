//
//  ZBForcastTableViewCell.m
//  TWWeather
//
//  Created by zonble on 2009/1/13.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "ZBForecastTableViewCell.h"

@implementation ZBForcastTableViewCellContentView
- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.opaque = NO;
	}
	return self;
}
- (void)drawRect:(CGRect)rect
{
	if (_delegate.lackingData) {
		[[UIImage imageNamed:@"Info.png"] drawInRect:CGRectMake(20, 20, 60, 60)];
		NSString *s = [NSString stringWithUTF8String:"沒有資料"];
		[s drawInRect:CGRectMake(100, 30, 200, 20) withFont:[UIFont boldSystemFontOfSize:20.0]];
		return;
	}
	
	[[UIColor blackColor] set];
	NSString *title = _delegate.title;	
	[title drawInRect:CGRectMake(90, 10, 200, 16) withFont:[UIFont boldSystemFontOfSize:14.0]];
	[[UIColor grayColor] set];
	NSString *date = _delegate.date;		
	[date drawInRect:CGRectMake(90, 30, 200, 16) withFont:[UIFont boldSystemFontOfSize:12.0]];
	
	[[UIColor blackColor] set];
	NSString *description = _delegate.description;
	[description drawInRect:CGRectMake(90, 54, 200, 40) withFont:[UIFont boldSystemFontOfSize:24.0]];	
	
	NSString *temperature = [_delegate.temperature stringByAppendingString:[NSString stringWithUTF8String:"℃"]];
	[temperature drawInRect:CGRectMake(90, 90, 200, 40) withFont:[UIFont boldSystemFontOfSize:18.0] lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentLeft];
	
	NSString *rain = [NSString stringWithFormat:@"%@ %@", [NSString stringWithUTF8String:"降雨機率"], _delegate.rain];
	[rain drawInRect:CGRectMake(90, 90, 200, 40) withFont:[UIFont boldSystemFontOfSize:16.0] lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentRight];

	
	UIImage *image = _delegate.forecastImage;
	[image drawInRect:CGRectMake(10, 10, 80, 50)];
	
}

@synthesize delegate = _delegate;

@end

@implementation ZBForecastTableViewCell

// @dynamic contentView;

- (void)dealloc 
{
	[_forecastContentView release];
	[_timeTitle release];
	[_date release];
	[_temperature release];
	[_rain release];
	[_description release];
	[_forecastImage release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		CGRect contentFrame = self.bounds;
		contentFrame.size.height = 150;
		contentFrame.origin.y += 2;
		contentFrame.size.height -= 4;
		_forecastContentView = [[ZBForcastTableViewCellContentView alloc] initWithFrame:contentFrame];
		_forecastContentView.delegate = self;
		[self addSubview:_forecastContentView];
		
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	[_forecastContentView setNeedsDisplay];
}
- (void)setiImageByCondition
{
	NSMutableString *string = [NSMutableString string];
	if ([_timeTitle isEqualToString:@"--"]) {
		[_forecastImage release];
		_forecastImage = nil;
		return;
	}
	
	if ([_timeTitle isEqualToString:[NSString stringWithUTF8String:"今晚至明晨"]] || [_timeTitle isEqualToString:[NSString stringWithUTF8String:"明晚後天"]])
		[string setString:@"Night"];
	else
		[string setString:@"Day"];
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

@synthesize title = _timeTitle;
@synthesize date = _date;
@synthesize temperature = _temperature;
@synthesize rain = _rain;
@synthesize description = _description;
@synthesize forecastImage = _forecastImage;
@synthesize lackingData = _lackingData;
@end
