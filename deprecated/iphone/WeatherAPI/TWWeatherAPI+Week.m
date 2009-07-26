//
//  TWWeatherAPI+Week.m
//  TWWeather
//
//  Created by zonble on 2009/1/17.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "TWWeatherAPI+Week.h"
#import "ZBFileCache.h"

@implementation TWWeatherAPI(Week)

- (void)parseWeekString:(NSString *)string delegate:(id)delegate name:(NSString *)name
{
	NSMutableArray *weekArray = [NSMutableArray array];
	NSArray *lines = [string componentsSeparatedByString:@"\n"];
	BOOL isHandlingData = NO;
	NSMutableDictionary *currentDictionary = nil;
	for (NSString *line in lines) {
		if (isHandlingData) {
			if ([weekArray count] && ![line length]) {
				isHandlingData = NO;
			}
			else if ([line hasPrefix:@"<p>"] && [line hasSuffix:@"<br />"]) {
				NSString *dateAndDescription = [line substringWithRange:NSMakeRange(3, [line length] - 9)];
				NSArray *dateAndDescriptionArray = [dateAndDescription componentsSeparatedByString:[NSString stringWithUTF8String:"　"]];
				NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
				NSString *date = [dateAndDescriptionArray objectAtIndex:0];
				NSString *description = [dateAndDescriptionArray objectAtIndex:1];
				[dictionary setValue:date forKey:@"date"];
				[dictionary setValue:description forKey:@"description"];
				currentDictionary = dictionary;
				[weekArray addObject:dictionary];
			}
			else if ([line hasSuffix:@"</p>"]) {
				NSString *temperature = [line substringToIndex:[line length] - 4];
				[currentDictionary setValue:temperature forKey:@"temperature"];
			}
		}
		else if ([line hasPrefix:[NSString stringWithUTF8String:"溫度"]]) {
			NSLog(@"handle");
			isHandlingData = YES;
		}
	}
	if ([delegate respondsToSelector:@selector(weekParsercDidComplete:name:week:)])
		[delegate weekParsercDidComplete:self name:name week:weekArray];
}
- (void)fetchWeekWithDelegate:(id)delegate name:(NSString *)name URLString:(NSString *)URLString
{
	if ([_request isRunning])
		[_request cancel];
	
	NSURL *URL = [NSURL URLWithString:URLString];
	ZBSessionInfo *info = [ZBSessionInfo info];
	info.URL = URL;
	info.type = zWeekType;
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
				[self parseWeekString:string delegate:delegate name:name];
				return;
			}
		}
	}
	
	if ([[Reachability sharedReachability] remoteHostStatus] != NotReachable) {
		[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];
		return;
	}
	
	if (string) {
		[self parseWeekString:string delegate:delegate name:name];
	}
	else {
		if (delegate && [delegate respondsToSelector:@selector(foreCastParserDidFail:)])
			[delegate foreCastParserDidFail:self];	
	}	
}
@end
