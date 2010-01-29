//
// TWAPIBox.m
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

#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"
#import "TWAPIBox+Cache.h"
#import "TWAPIBox+Private.h"

NSString *TWAPIErrorDomain = @"TWAPIErrorDomain";

static TWAPIBox *apibox;

#define BASE_URL_STRING @"http://3.latest.twweatherapi.appspot.com/"

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
	_currentSessionInfo = nil;
	_currentURL = nil;

	[_request cancelWithoutDelegateMessage];
	_request.delegate = nil;
	[_request release];
	[_queue release];
	[self releaseInfoArrays];
	[_formatter release];
	[_reachability release];
	[_retryCountDictionary release];
	[super dealloc];
}

- (id)init
{
	self = [super init];
    if (self) {
		_reachability = [[LFSiteReachability alloc] init];
		_reachability.siteURL = [NSURL URLWithString:BASE_URL_STRING];
		_reachability.timeoutInterval = 5.0;
		_reachability.delegate = self;
		_request = [[LFHTTPRequest alloc] init];
		_request.timeoutInterval = 5.0;
		[_request setDelegate:self];
		_queue = [[NSMutableArray alloc] init];
		_retryCountDictionary = [[NSMutableDictionary alloc] init];
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
	if (!delegate) {
		return;
	}
	
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

- (void)performFetchWithSessionInfo:(id)sessionInfo URL:(NSURL *)URL
{
	_currentURL = [URL retain];
	_currentSessionInfo = [sessionInfo retain];
	[_reachability startChecking];
	
//	[_request setSessionInfo:sessionInfo];
//	[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];	
//
}

- (void)runQueue
{
	if ([_queue count] && ![_request isRunning] && ![_reachability isChecking]) {
		id sessionInfo = [_queue objectAtIndex:0];
		NSURL *URL = [sessionInfo objectForKey:@"URL"];
		[self performFetchWithSessionInfo:sessionInfo URL:URL];
		[_queue removeObject:sessionInfo];
	}
}

- (void)sendRequestWithPath:(NSString *)path identifier:(NSString *)identifier action:(SEL)action failedAction:(SEL)failedAction delegate:(id)delegate userInfo:(id)userInfo
{
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
			_request.sessionInfo = sessionInfo;
			[self didFetchImage:_request data:data];
			return;
		}
	}

	if ([_queue count]) {
		[_queue insertObject:sessionInfo atIndex:0];
	}
	else {
		[_queue addObject:sessionInfo];
	}
	[self runQueue];
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
	NSString *path = [NSString stringWithFormat:@"image?id=%@&redirect=0", identifier];
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:identifier, @"identifier", userInfo, @"userInfo", nil];
	[self sendRequestWithPath:path identifier:@"image" action:@selector(didFetchImage:data:) failedAction:@selector(didFailedFetchImage:error:) delegate:delegate userInfo:info];		
}
- (void)fetchOBSWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"obs?location=%@", identifier];
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:identifier, @"identifier", userInfo, @"userInfo", nil];
	[self sendRequestWithPath:path identifier:@"obs" action:@selector(didFetchForecast:data:) failedAction:@selector(didFailedFetchForecast:error:) delegate:delegate userInfo:info];	
}
- (void)setShouldWaitUntilDone:(BOOL)flag
{
	[_request setShouldWaitUntilDone:flag];
}
- (BOOL)shouldWaitUntilDone
{
	return [_request shouldWaitUntilDone];
}

- (NSURL *)imageURLFromIdentifier:(NSString *)identifier
{
	NSString *path = [NSString stringWithFormat:@"image?id=%@&redirect=0", identifier];
	NSString *URLString = [BASE_URL_STRING stringByAppendingString:path];
	NSURL *URL = [NSURL URLWithString:URLString];
	return URL;
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
	if (!_formatter) {
		_formatter = [[NSDateFormatter alloc] init];
	}
	[_formatter setDateStyle:kCFDateFormatterShortStyle];
	[_formatter setTimeStyle:kCFDateFormatterShortStyle];
	if (!date) {
		return nil;
	}	
	return [_formatter stringFromDate:[[date retain] autorelease]];	
}
- (NSString *)shortDateStringFromDate:(NSDate *)date
{
	if (!_formatter) {
		_formatter = [[NSDateFormatter alloc] init];
	}
	[_formatter setDateStyle:kCFDateFormatterShortStyle];
	[_formatter setTimeStyle:kCFDateFormatterNoStyle];
	
	if (!date) {
		return nil;
	}	
	NSMutableString *s = [NSMutableString stringWithString:[_formatter stringFromDate:[[date retain] autorelease]]];
	[_formatter setDateFormat:@"EEE"];
	[s appendFormat:@" %@", [_formatter stringFromDate:date]];
	return s;
}

#pragma mark -

- (void)httpRequestDidComplete:(LFHTTPRequest *)request
{
	NSData *data = [request receivedData];
	NSURL *URL = [request.sessionInfo objectForKey:@"URL"];	
	NSUInteger retryCount = [[_retryCountDictionary valueForKey:[URL absoluteString]] intValue];
	
	if (![data length] && !retryCount) {
		[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];		
		retryCount++;
		[_retryCountDictionary setObject:[NSNumber numberWithInt:retryCount] forKey:[URL absoluteString]];
		return;
	}
	[_retryCountDictionary removeObjectForKey:[URL absoluteString]];
	
	NSMutableDictionary *sessionInfo = request.sessionInfo;
	[sessionInfo setObject:[NSDate date] forKey:@"date"];
	 
	NSString *actionString = [[request sessionInfo] objectForKey:@"action"];
	SEL action = NSSelectorFromString(actionString);

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
	
	NSUInteger retryCount = [[_retryCountDictionary valueForKey:[URL absoluteString]] intValue];
	
	if (!retryCount) {
		[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];		
		retryCount++;
		[_retryCountDictionary setObject:[NSNumber numberWithInt:retryCount] forKey:[URL absoluteString]];
		return;
	}
	[_retryCountDictionary removeObjectForKey:[URL absoluteString]];
	

	if (URL) {
		NSData *data = [self dataInCacheForURL:URL];
		NSMutableDictionary *sessionInfo = request.sessionInfo;
		NSDate *date = [self dateOfCacheForURL:URL];
		[sessionInfo setObject:date forKey:@"date"];

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

#pragma mark -

- (void)reachability:(LFSiteReachability *)inReachability site:(NSURL *)inURL isAvailableOverConnectionType:(NSString *)inConnectionType
{
	[_request setSessionInfo:[_currentSessionInfo autorelease]];
	[_request performMethod:LFHTTPRequestGETMethod onURL:[_currentURL autorelease] withData:nil];	
	[inReachability stopChecking];
	_currentSessionInfo = nil;
	_currentURL = nil;
	
}
- (void)reachability:(LFSiteReachability *)inReachability siteIsNotAvailable:(NSURL *)inURL
{
	[_request setSessionInfo:[_currentSessionInfo autorelease]];
	[_currentURL autorelease];
	[self httpRequest:_request didFailWithError:LFHTTPRequestConnectionError];
	[inReachability stopChecking];
	_currentSessionInfo = nil;
	_currentURL = nil;
}


	
@end
