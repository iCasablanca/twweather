//
//  TWWeatherAPI.m
//  TWWeather
//
//  Created by zonble on 2009/1/17.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "TWWeatherAPI.h"
#import "TWWeatherAPI+OverViewParser.h"
#import "TWWeatherAPI+ForecastParser.h"
#import "TWWeatherAPI+Graphic.h"
#import "TWWeatherAPI+Week.h"
#import "ZBFileCache.h"
#import "Reachability.h"

@implementation ZBSessionInfo

+ (id)info
{
	ZBSessionInfo *info = [[[ZBSessionInfo alloc] init] autorelease];
	return info;
}
- (void) dealloc
{
	[_type release];
	[_name release];
	[_URL release];
	[super dealloc];
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		_type = nil;
		_name = nil;
		_URL = nil;
		_delegate = nil;
	}
	return self;
}

@synthesize type = _type;
@synthesize name = _name;
@synthesize URL = _URL;
@synthesize delegate = _delegate;

@end

static TWWeatherAPI *weatherAPI;

@implementation TWWeatherAPI

+ (id)sharedAPI
{
	if (!weatherAPI)
		weatherAPI = [TWWeatherAPI new];
	return weatherAPI;
}
- (void)dealloc
{
	if ([_request isRunning])
		[_request cancel];
	[_request release];
	[super dealloc];
}
- (id)init
{
	self = [super init];
	if (self != nil) {
		_request = [LFHTTPRequest new];
		_request.delegate = self;
		_request.timeoutInterval = 5.0;
	}
	return self;
}

#pragma mark -

- (void)httpRequestDidComplete:(LFHTTPRequest *)request
{
	ZBSessionInfo *info = (ZBSessionInfo *)request.sessionInfo;
	NSData *data = request.receivedData;
	if (data) {
		NSURL *URL = info.URL;
		NSString *path = [ZBFileCache cachePathForURL:URL];
		[data writeToFile:path atomically:YES];
		NSString *type = info.type;
		if ([type isEqual:zOverviewType]) {
			NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			[string autorelease];
			[self parseOverviewString:string delegate:info.delegate];
		}
		else if ([type isEqual:zForecastType]) {
			NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			[string autorelease];
			[self parseForecastString:string delegate:info.delegate name:info.name];
		}
		else if ([type isEqual:zGraphicType]) {
			UIImage *image = [UIImage imageWithData:data];
			[self loadImage:image delegate:info.delegate name:info.name];
		}
		else if ([type isEqual:zWeekType]) {
			NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			[string autorelease];
			[self parseWeekString:string delegate:info.delegate name:info.name];			
		}
	}
	else {
		[self httpRequest:request didFailWithError:nil];
	}
	
}
- (void)httpRequestDidCancel:(LFHTTPRequest *)request
{
}
- (void)httpRequest:(LFHTTPRequest *)request didFailWithError:(NSString *)error
{
	ZBSessionInfo *info = (ZBSessionInfo *)request.sessionInfo;
	NSString *type = info.type;
	if ([type isEqual:zOverviewType]) {
		[info.delegate overviewParserDidFail:self];
	}
	else if ([type isEqual:zForecastType]) {
		[info.delegate foreCastParserDidFail:self];
	}
	else if ([type isEqual:zGraphicType]) {
		[info.delegate graphicDidFail:self];
	}
	else if ([type isEqual:zWeekType]) {
		[info.delegate weekParserDidFail:self];
	}
	
}

@end
