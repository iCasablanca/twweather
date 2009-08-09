//
// TWAPIBox.m
//
// Copyright (c) 2009 Weizhong Yang (http://zonble.net)
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"
#import "TWAPIBox+Cache.h"
#import "TWAPIBox+Private.h"

NSString *TWAPIErrorDomain = @"TWAPIErrorDomain";

static TWAPIBox *apibox;

#define BASE_URL_STRING @"http://twweatherapi.appspot.com/"

@implementation TWAPIBox

+ (TWAPIBox *)sharedBox
{
	if (!apibox) {
		apibox = [[TWAPIBox alloc] init];
	}
	return apibox;
}

- (void)dealloc
{
	[_request cancelWithoutDelegateMessage];
	_request.delegate = nil;
	[_request release];
	[_queue release];
	[self releaseInfoArrays];
	[_formatter release];
	[super dealloc];
}

- (id)init
{
	self = [super init];
    if (self) {
		_request = [[LFHTTPRequest alloc] init];
		[_request setDelegate:self];
//		[_request setTimeoutInterval:20.0];
		_queue = [[NSMutableArray alloc] init];
		[self initInfoArrays];
    }
    return self;
}

- (void)cancelAllRequest
{
	[_request cancelWithoutDelegateMessage];
	[_queue removeAllObjects];
}
- (void)cancelAllRequestWithDelegate:(id)delegate
{
	NSEnumerator *enumerator = [_queue objectEnumerator];
	id sessionInfo = nil;
	while (sessionInfo = [enumerator nextObject]) {
		id theDelegate = [sessionInfo objectForKey:@"delegate"];
		if (theDelegate == delegate) {
			[_queue removeObject:sessionInfo];
		}
	}
	if ([_request isRunning]) {
		id sessionInfo = [_request sessionInfo];
		id theDelegate = [sessionInfo objectForKey:@"delegate"];
		if (theDelegate == delegate) {
			[_request cancelWithoutDelegateMessage];
			[self runQueue];
		}
	}
}
- (void)runQueue
{
	if ([_queue count]) {
//		NSLog(@"runQueue");
		id sessionInfo = [_queue objectAtIndex:0];
		NSURL *URL = [sessionInfo objectForKey:@"URL"];
		[_request setSessionInfo:sessionInfo];
		[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];
		[_queue removeObject:sessionInfo];		
	}
}

- (void)sendRequestWithPath:(NSString *)path identifier:(NSString *)identifier action:(SEL)action failedAction:(SEL)failedAction delegate:(id)delegate userInfo:(id)userInfo
{
//	[_request cancelWithoutDelegateMessage];
	NSMutableDictionary *sessionInfo = [NSMutableDictionary dictionary];
	if (delegate)
		[sessionInfo setObject:delegate forKey:@"delegate"];
	if (userInfo)
		[sessionInfo setObject:userInfo forKey:@"userInfo"];
	if (identifier)
		[sessionInfo setObject:identifier forKey:@"identifier"];
	[sessionInfo setObject:NSStringFromSelector(action) forKey:@"action"];
	[sessionInfo setObject:NSStringFromSelector(failedAction) forKey:@"failedAction"];
	NSString *URLString = [BASE_URL_STRING stringByAppendingString:path];
	NSURL *URL = [NSURL URLWithString:URLString];
	[sessionInfo setObject:URL forKey:@"URL"];

	if ([identifier isEqualToString:@"image"]) {
		if ([self shouldUseCachedDataForURL:URL]) {
			NSData *data = [self dataInCacheForURL:URL];
			[self didFetchImage:_request data:data];
			return;
		}
	}
	
	if (![_queue count] && ![_request isRunning]) {
		[_request setSessionInfo:sessionInfo];
		[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];
	}
	else {
		[_queue addObject:sessionInfo];
	}
	
}

#pragma mark -

- (void)fetchWarningsWithDelegate:(id)delegate userInfo:(id)userInfo
{	
	NSString *path = @"warning";
	[self sendRequestWithPath:path identifier:@"warning" action:@selector(didFetchWarning:data:) failedAction:@selector(didFailedFetchWarning:error:) delegate:delegate userInfo:userInfo];
	
}
- (void)fetchOverviewWithFormat:(TWOverviewFormat)format delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = @"overview";
	if (format == TWOverviewPlainFormat) {
		path = @"overview?output=plain";
	}
	[self sendRequestWithPath:path identifier:@"overview" action:@selector(didFetchOverview:data:) failedAction:@selector(didFailedFetchOverview:error:) delegate:delegate userInfo:userInfo];
}
- (void)fetchAllForecastsWithDelegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"forecast?location=all"];
	[self sendRequestWithPath:path identifier:@"forecastAll" action:@selector(didFetchWarning:data:) failedAction:@selector(didFailedFetchWarning:error:) delegate:delegate userInfo:userInfo];	
}
- (void)fetchForecastWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	if (!identifier) {
		return;
	}
	NSString *path = [NSString stringWithFormat:@"forecast?location=%@", identifier];
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:identifier, @"identifier", userInfo, @"userInfo", nil];
	[self sendRequestWithPath:path identifier:@"forecast" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];
}
- (void)fetchWeekWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"week?location=%@", identifier];
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:identifier, @"identifier", userInfo, @"userInfo", nil];
	[self sendRequestWithPath:path identifier:@"week" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];	
}
- (void)fetchWeekTravelWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"week_travel?location=%@", identifier];
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:identifier, @"identifier", userInfo, @"userInfo", nil];
	[self sendRequestWithPath:path identifier:@"week_travel" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];		
}
- (void)fetchThreeDaySeaWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"3sea?location=%@", identifier];
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:identifier, @"identifier", userInfo, @"userInfo", nil];
	[self sendRequestWithPath:path identifier:@"3sea" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];	
}
- (void)fetchNearSeaWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"nearsea?location=%@", identifier];
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:identifier, @"identifier", userInfo, @"userInfo", nil];
	[self sendRequestWithPath:path identifier:@"nearsea" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];		
}
- (void)fetchTideWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"tide?location=%@", identifier];
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:identifier, @"identifier", userInfo, @"userInfo", nil];
	[self sendRequestWithPath:path identifier:@"tide" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];	
}
- (void)fetchImageWithIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"image?id=%@&redirect=1", identifier];
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:identifier, @"identifier", userInfo, @"userInfo", nil];
	[self sendRequestWithPath:path identifier:@"image" action:@selector(didFetchImage:data:) failedAction:@selector(didFailedFetchImage:error:) delegate:delegate userInfo:info];		
}
- (void)fetchOBSWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"obs?location=%@", identifier];
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:identifier, @"identifier", userInfo, @"userInfo", nil];
	[self sendRequestWithPath:path identifier:@"obs" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];	
	
}

#pragma mark -

- (NSDate *)dateFromString:(NSString *)string
{
	if (!string) {
		return nil;
	}	
	if (!_formatter) {
		_formatter = [[NSDateFormatter alloc] init];
	}
	[_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *date = [_formatter dateFromString:string];
	return date;	
}
- (NSDate *)dateFromShortString:(NSString *)string
{
	if (!string) {
		return nil;
	}
	if (!_formatter) {
		_formatter = [[NSDateFormatter alloc] init];
	}
	[_formatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *date = [_formatter dateFromString:string];
	return date;	
}
- (NSString *)shortDateTimeStringFromDate:(NSDate *)date
{
	if (!date) {
		return nil;
	}	
	if (!_formatter) {
		_formatter = [[NSDateFormatter alloc] init];
	}
	[_formatter setDateStyle:kCFDateFormatterShortStyle];
	[_formatter setTimeStyle:kCFDateFormatterShortStyle];
	return [_formatter stringFromDate:date];	
}
- (NSString *)shortDateStringFromDate:(NSDate *)date
{
	if (!date) {
		return nil;
	}	
	if (!_formatter) {
		_formatter = [[NSDateFormatter alloc] init];
	}
	[_formatter setDateStyle:kCFDateFormatterShortStyle];
	[_formatter setTimeStyle:kCFDateFormatterNoStyle];
	return [_formatter stringFromDate:date];	
}

#pragma mark -

- (void)httpRequestDidComplete:(LFHTTPRequest *)request
{
	NSString *actionString = [[request sessionInfo] objectForKey:@"action"];
	SEL action = NSSelectorFromString(actionString);
	NSURL *URL = [[request sessionInfo] objectForKey:@"URL"];
	NSData *data = [request receivedData];
	if (URL) {
		[self writeDataToCache:data fromURL:URL];
	}
	[self performSelector:action withObject:request withObject:data];
	[self runQueue];
}
- (void)httpRequestDidCancel:(LFHTTPRequest *)request
{
	NSString *actionString = [[request sessionInfo] objectForKey:@"action"];
	SEL action = NSSelectorFromString(actionString);
	[self performSelector:action withObject:request withObject:nil];
	[self runQueue];
}
- (void)httpRequest:(LFHTTPRequest *)request didFailWithError:(NSString *)error;
{
	NSURL *URL = [[request sessionInfo] objectForKey:@"URL"];
	if (URL) {
		NSData *data = [self dataInCacheForURL:URL];
		if (data) {
			NSString *actionString = [[request sessionInfo] objectForKey:@"action"];
			SEL action = NSSelectorFromString(actionString);
			[self performSelector:action withObject:request withObject:data];
			return;
		}
	}
	
	NSString *failedActionString = [[request sessionInfo] objectForKey:@"failedAction"];
	SEL failedAction = NSSelectorFromString(failedActionString);
	[self performSelector:failedAction withObject:request withObject:error];
	[self runQueue];
}
	
	
@end
