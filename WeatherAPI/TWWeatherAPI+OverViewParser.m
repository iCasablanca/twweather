//
//  TWWeatherAPI+OverViewParser.m
//  TWWeather
//
//  Created by zonble on 2009/1/17.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "TWWeatherAPI+OverViewParser.h"

@implementation TWWeatherAPI(OverViewParser)

- (void)parseOverviewString:(NSString *)string delegate:(id)delegate
{
	NSMutableString *text = [NSMutableString string];
	NSArray *a = [string componentsSeparatedByString:@"\n"];
	NSString *s = nil;
	if ([a count] < 12)
		return;
	s = [[a objectAtIndex:11] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
	[text setString:[s stringByReplacingOccurrencesOfString:[NSString stringWithUTF8String:"　　"] withString:@"\n\n"]];
	if (delegate && [delegate respondsToSelector:@selector(overviewParserDidComplete:text:)])
		[delegate overviewParserDidComplete:self text:text];
}

- (void)fetchOverviewWithDelegate:(id)delegate
{
	if ([_request isRunning])
		[_request cancel];
	
	NSURL *URL = [NSURL URLWithString:@"http://www.cwb.gov.tw/mobile/real.wml"];
	ZBSessionInfo *info = [ZBSessionInfo info];
	info.URL = URL;
	info.type = zOverviewType;
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
				[self parseOverviewString:string delegate:delegate];
				return;
			}
		}
	}
	
	if ([[Reachability sharedReachability] remoteHostStatus] != NotReachable) {
		[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];
		return;
	}
	
	if (string) {
		[self parseOverviewString:string delegate:delegate];
	}
	else {
		if (delegate && [delegate respondsToSelector:@selector(overviewParserDidFail:)])
			[delegate overviewParserDidFail:self];	
	}
}
@end
