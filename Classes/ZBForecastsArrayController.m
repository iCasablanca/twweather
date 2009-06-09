//
//  ZBForecastsArrayController.m
//  TWWeather
//
//  Created by zonble on 2009/1/12.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "ZBForecastsArrayController.h"


@implementation ZBForecastsArrayController

- (void) dealloc
{
	[_array release];
	[super dealloc];
}
- (void)_addLocationWithName:(NSString *)name URLString:(NSString *)URLString
{
	NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", URLString, @"URLString", nil];
	[_array addObject:d];
}

- (id)init
{
	self = [super init];
	if (self != nil) {
		_array = [NSMutableArray new];
		[self _addLocationWithName:[NSString stringWithUTF8String:"台北市"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_01.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"高雄市"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_02.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"基隆"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_03.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"台北"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_04.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"桃園"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_05.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"新竹"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_06.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"苗栗"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_07.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"台中"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_08.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"彰化"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_09.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"南投"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_10.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"雲林"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_11.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"嘉義"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_12.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"台南"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_13.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"高雄"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_14.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"屏東"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_15.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"恆春"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_16.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"宜蘭"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_17.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"花蓮"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_18.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"台東"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_19.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"澎湖"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_20.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"金門"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_21.wml"];
		[self _addLocationWithName:[NSString stringWithUTF8String:"馬祖"]
                         URLString:@"http://www.cwb.gov.tw/mobile/forecast/city_22.wml"];
	}
	return self;
}

@synthesize array = _array;

@end
