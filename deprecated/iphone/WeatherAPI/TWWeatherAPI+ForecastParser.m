//
//  TWWeatherAPI+ForecastParser.m
//  TWWeather
//
//  Created by zonble on 2009/1/17.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "TWWeatherAPI+ForecastParser.h"

@implementation TWWeatherAPI(ForecastParser)

- (void)parseForecastString:(NSString *)string delegate:(id)delegate name:(NSString *)name
{
	NSMutableArray *forecasts = [NSMutableArray array];
	
	BOOL isHandlingTime = NO;
	BOOL isHandlingDescription = NO;
	
	NSArray *stringArray = [string componentsSeparatedByString:@"\n"];
	NSMutableDictionary *currentDictionary = nil;
	for (NSString *line in stringArray) {
		if ([line hasPrefix:[NSString stringWithUTF8String:"降雨機率："]]) {
			NSString *s = [line substringFromIndex:5];
			s = [s stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
			[currentDictionary setValue:s forKey:kRain];
		}
		else if ([line hasPrefix:[NSString stringWithUTF8String:"溫度(℃)："]]) {
			NSString *s = [line substringFromIndex:6];
			s = [s stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
			[currentDictionary setValue:s forKey:kTemperature];
		}
		else if (isHandlingTime) {
			NSString *s = [line stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
			[currentDictionary setValue:s forKey:kTimeDate];
			isHandlingTime = NO;
			isHandlingDescription = YES;
		}
		else if (isHandlingDescription && ![line hasPrefix:@"<br />"] ) {
			NSString *s = [line stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
			[currentDictionary setValue:s forKey:kDescription];
			isHandlingDescription = NO;
		}
		else if ([line hasPrefix:[NSString stringWithUTF8String:"今日白天"]]) {
			NSMutableDictionary *d = [NSMutableDictionary dictionary];
			[d setValue:[NSString stringWithUTF8String:"今日白天"] forKey:kTimeTitle];
			isHandlingTime = YES;
			[forecasts addObject:d];
			currentDictionary = d;
			continue;
		}
		else if ([line hasPrefix:[NSString stringWithUTF8String:"今晚至明晨"]]) {
			NSMutableDictionary *d = [NSMutableDictionary dictionary];
			[d setValue:[NSString stringWithUTF8String:"今晚至明晨"] forKey:kTimeTitle];
			isHandlingTime = YES;
			[forecasts addObject:d];
			currentDictionary = d;
			continue;
		}
		else if ([line hasPrefix:[NSString stringWithUTF8String:"明日白天"]]) {
			NSMutableDictionary *d = [NSMutableDictionary dictionary];
			[d setValue:[NSString stringWithUTF8String:"明日白天"] forKey:kTimeTitle];
			isHandlingTime = YES;
			[forecasts addObject:d];
			currentDictionary = d;
			continue;
		}
		if ([line hasPrefix:[NSString stringWithUTF8String:"明晚後天"]]) {
			NSMutableDictionary *d = [NSMutableDictionary dictionary];
			[d setValue:[NSString stringWithUTF8String:"明晚後天"] forKey:kTimeTitle];
			isHandlingTime = YES;
			[forecasts addObject:d];
			currentDictionary = d;
			continue;
		}			
	}
	if (delegate && [delegate respondsToSelector:@selector(foreCastParserDidComplete:name:forecasts:)])
		[delegate foreCastParserDidComplete:self name:name forecasts:forecasts];
}
- (void)fetchForecastWithDelegate:(id)delegate name:(NSString *)name URLString:(NSString *)URLString
{
	if ([_request isRunning])
		[_request cancel];
	
	NSURL *URL = [NSURL URLWithString:URLString];
	ZBSessionInfo *info = [ZBSessionInfo info];
	info.URL = URL;
	info.type = zForecastType;
	info.name = name;
	info.delegate = delegate;
	_request.sessionInfo = info;
	
	NSString *string  = nil;
	NSString *path = [ZBFileCache cachePathForURL:URL];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSDate *fileModDate;
		NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:path traverseLink:YES];
		if (fileModDate = [fileAttributes objectForKey:NSFileModificationDate]) {
			string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			if ([fileModDate timeIntervalSinceNow] > -60.0 * 5) {
				[self parseForecastString:string delegate:delegate name:name];
				return;
			}
		}
	}
	
	if ([[Reachability sharedReachability] remoteHostStatus] != NotReachable) {
		[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];
		return;
	}
	
	if (string) {
		[self parseForecastString:string delegate:delegate name:name];
	}
	else {
		if (delegate && [delegate respondsToSelector:@selector(foreCastParserDidFail:)])
			[delegate foreCastParserDidFail:self];	
	}
}

@end
