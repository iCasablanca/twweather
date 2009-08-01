//
//  TWAPIBox.m
//  Created by zonble on 2009/07/31.
//

#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"
#import "TWAPIBox+Cache.h"

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
		[self initInfoArrays];
    }
    return self;
}

#pragma mark -

- (NSDictionary *)_errorDictionaryWithCode:(int)code
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	if (code == TWAPIConnectionError) {
		[dictionary setObject:NSLocalizedString(@"Connection Error", @"") forKey:NSLocalizedDescriptionKey];
	}
	else if (code == TWAPITimeOutError) {
		[dictionary setObject:NSLocalizedString(@"Connection Time Out", @"") forKey:NSLocalizedDescriptionKey];
	}
	else if (code == TWAPIDataError) {
		[dictionary setObject:NSLocalizedString(@"Data Error", @"") forKey:NSLocalizedDescriptionKey];
	}
	return dictionary;
}

- (void)didFetchOverview:(LFHTTPRequest *)request data:(NSData *)data
{
	NSString *string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	if (!string) {
		string = @"";
	}
	NSDictionary *sessionInfo = [request sessionInfo];
	id delegate = [sessionInfo objectForKey:@"delegate"];
	if (delegate && [delegate respondsToSelector:@selector(APIBox:didFetchOverview:userInfo:)]) {
		[delegate APIBox:self didFetchOverview:string userInfo:[sessionInfo objectForKey:@"userInfo"]];
	}
}
- (void)didFailedFetchOverview:(LFHTTPRequest *)request error:(NSString *)error
{
	NSInteger code = 0;
	if (error == LFHTTPRequestConnectionError) {
		code = TWAPIConnectionError;
	}
	else if (error == LFHTTPRequestTimeoutError) {
		code = TWAPITimeOutError;
	}
	NSError *theError = [NSError errorWithDomain:TWAPIErrorDomain code:code userInfo:[self _errorDictionaryWithCode:code]];
	NSDictionary *sessionInfo = [request sessionInfo];
	id delegate = [sessionInfo objectForKey:@"delegate"];

	if (delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchOverviewWithError:)]) {
		[delegate APIBox:self didFailedFetchOverviewWithError:theError];
	}	
}
- (void)didFetchForecast:(LFHTTPRequest *)request data:(NSData *)data
{
	NSDictionary *sessionInfo = [request sessionInfo];
	id delegate = [sessionInfo objectForKey:@"delegate"];
	NSString *identifier = [sessionInfo objectForKey:@"identifier"];
	NSDictionary *info = [sessionInfo objectForKey:@"userInfo"];
	NSString *inIdentifier = [info objectForKey:@"identifier"];
	id userInfo = [info objectForKey:@"userInfo"];
	
	NSPropertyListFormat format;
	NSString *error;
	id plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
	id result = [plist objectForKey:@"result"];
	if (result) {
		if ([identifier isEqualToString:@"forecast"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFetchForecast:identifier:userInfo:)]) {
			[delegate APIBox:self didFetchForecast:result identifier:inIdentifier userInfo:userInfo];
		}
		else if ([identifier isEqualToString:@"week"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFetchWeek:identifier:userInfo:)]) {
			[delegate APIBox:self didFetchWeek:result identifier:inIdentifier userInfo:userInfo];
		}
		else if ([identifier isEqualToString:@"week_travel"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFetchWeekTravel:identifier:userInfo:)]) {
			[delegate APIBox:self didFetchWeekTravel:result identifier:inIdentifier userInfo:userInfo];
		}
		else if ([identifier isEqualToString:@"3sea"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFetchThreeDaySea:identifier:userInfo:)]) {
			[delegate APIBox:self didFetchThreeDaySea:result identifier:inIdentifier userInfo:userInfo];
		}
		else if ([identifier isEqualToString:@"nearsea"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFetchNearSea:identifier:userInfo:)]) {
			[delegate APIBox:self didFetchNearSea:result identifier:inIdentifier userInfo:userInfo];
		}
		else if ([identifier isEqualToString:@"tide"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFetchTide:identifier:userInfo:)]) {
			[delegate APIBox:self didFetchTide:result identifier:inIdentifier userInfo:userInfo];
		}
	}
	else {
		NSInteger code = TWAPIDataError;
		NSError *theError = [NSError errorWithDomain:TWAPIErrorDomain code:code userInfo:[self _errorDictionaryWithCode:code]];
		if ([identifier isEqualToString:@"forecast"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchForecastWithError:identifier:userInfo:)]) {
			[delegate APIBox:self didFailedFetchForecastWithError:theError identifier:inIdentifier userInfo:userInfo];
		}
		else if ([identifier isEqualToString:@"week"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchWeekWithError:identifier:userInfo:)]) {
			[delegate APIBox:self didFailedFetchWeekWithError:theError identifier:inIdentifier userInfo:userInfo];
		}
		else if ([identifier isEqualToString:@"week_travel"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchWeekTravelWithError:identifier:userInfo:)]) {
			[delegate APIBox:self didFailedFetchWeekTravelWithError:theError identifier:inIdentifier userInfo:userInfo];
		}
		else if ([identifier isEqualToString:@"3sea"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchThreeDaySeaWithError:identifier:userInfo:)]) {
			[delegate APIBox:self didFailedFetchThreeDaySeaWithError:theError identifier:inIdentifier userInfo:userInfo];
		}
		else if ([identifier isEqualToString:@"nearsea"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchNearSeaWithError:identifier:userInfo:)]) {
			[delegate APIBox:self didFailedFetchNearSeaWithError:theError identifier:inIdentifier userInfo:userInfo];
		}
		else if ([identifier isEqualToString:@"tide"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchTideWithError:identifier:userInfo:)]) {
			[delegate APIBox:self didFailedFetchTideWithError:theError identifier:inIdentifier userInfo:userInfo];
		}
	}
		
}
- (void)didFailedFetchForecast:(LFHTTPRequest *)request error:(NSString *)error
{
	NSDictionary *sessionInfo = [request sessionInfo];
	id delegate = [sessionInfo objectForKey:@"delegate"];
	NSString *identifier = [sessionInfo objectForKey:@"identifier"];
	NSDictionary *info = [sessionInfo objectForKey:@"userInfo"];
	NSString *inIdentifier = [info objectForKey:@"identifier"];
	id userInfo = [info objectForKey:@"userInfo"];	
	
	NSInteger code = TWAPIUnkownError;
	if (error == LFHTTPRequestConnectionError) {
		code = TWAPIConnectionError;
	}
	else if (error == LFHTTPRequestTimeoutError) {
		code = TWAPITimeOutError;
	}
	NSError *theError = [NSError errorWithDomain:TWAPIErrorDomain code:code userInfo:[self _errorDictionaryWithCode:code]];
	if ([identifier isEqualToString:@"forecast"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchForecastWithError:identifier:userInfo:)]) {
		[delegate APIBox:self didFailedFetchForecastWithError:theError identifier:inIdentifier userInfo:userInfo];
	}
	else if ([identifier isEqualToString:@"week"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchWeekWithError:identifier:userInfo:)]) {
		[delegate APIBox:self didFailedFetchWeekWithError:theError identifier:inIdentifier userInfo:userInfo];
	}
	else if ([identifier isEqualToString:@"week_travel"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchWeekTravelWithError:identifier:userInfo:)]) {
		[delegate APIBox:self didFailedFetchWeekTravelWithError:theError identifier:inIdentifier userInfo:userInfo];
	}
	else if ([identifier isEqualToString:@"3sea"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchThreeDaySeaWithError:identifier:userInfo:)]) {
		[delegate APIBox:self didFailedFetchThreeDaySeaWithError:theError identifier:inIdentifier userInfo:userInfo];
	}
	else if ([identifier isEqualToString:@"nearsea"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchNearSeaWithError:identifier:userInfo:)]) {
		[delegate APIBox:self didFailedFetchNearSeaWithError:theError identifier:inIdentifier userInfo:userInfo];
	}
	else if ([identifier isEqualToString:@"tide"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchTideWithError:identifier:userInfo:)]) {
		[delegate APIBox:self didFailedFetchTideWithError:theError identifier:inIdentifier userInfo:userInfo];
	}
}
- (void)didFetchImage:(LFHTTPRequest *)request data:(NSData *)data
{
	NSDictionary *sessionInfo = [request sessionInfo];
	id delegate = [sessionInfo objectForKey:@"delegate"];
	NSDictionary *info = [sessionInfo objectForKey:@"userInfo"];
	NSString *inIdentifier = [info objectForKey:@"identifier"];
	id userInfo = [info objectForKey:@"userInfo"];
	if (delegate && [delegate respondsToSelector:@selector(APIBox:didFetchImageData:identifier:userInfo:)]) {
		[delegate APIBox:self didFetchImageData:data identifier:inIdentifier userInfo:userInfo];
	}
}
- (void)didFailedFetchImage:(LFHTTPRequest *)request error:(NSString *)error
{
	NSDictionary *sessionInfo = [request sessionInfo];
	id delegate = [sessionInfo objectForKey:@"delegate"];
	NSDictionary *info = [sessionInfo objectForKey:@"userInfo"];
	NSString *inIdentifier = [info objectForKey:@"identifier"];
	id userInfo = [info objectForKey:@"userInfo"];	

	NSInteger code = TWAPIUnkownError;
	if (error == LFHTTPRequestConnectionError) {
		code = TWAPIConnectionError;
	}
	else if (error == LFHTTPRequestTimeoutError) {
		code = TWAPITimeOutError;
	}
	NSError *theError = [NSError errorWithDomain:TWAPIErrorDomain code:code userInfo:[self _errorDictionaryWithCode:code]];	
	
	if (delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchImageWithError:identifier:userInfo:)]) {
		[delegate APIBox:self didFailedFetchImageWithError:theError identifier:inIdentifier userInfo:userInfo];
	}
}

- (void)sendRequestWithPath:(NSString *)path identifier:(NSString *)identifier action:(SEL)action failedAction:(SEL)failedAction delegate:(id)delegate userInfo:(id)userInfo
{
	[_request cancelWithoutDelegateMessage];
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
	_request.sessionInfo = sessionInfo;

	if ([identifier isEqualToString:@"image"]) {
		if ([self shouldUseCachedDataForURL:URL]) {
			NSData *data = [self dataInCacheForURL:URL];
			[self didFetchImage:_request data:data];
			return;
		}
	}
	[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];
}

#pragma mark -

- (void)fetchOverviewWithFormat:(TWOverviewFormat)format delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = @"overview";
	if (format == TWOverviewPlainFormat) {
		path = @"overview?output=plain";
	}
	[self sendRequestWithPath:path identifier:@"overview" action:@selector(didFetchOverview:data:) failedAction:@selector(didFailedFetchOverview:error:) delegate:delegate userInfo:userInfo];
}
- (void)fetchForecastWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"forecast?location=%@", identifier];
	if (!identifier) {
		return;
	}
	if (!userInfo) {
		userInfo = [NSNull null];
	}
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
- (void)fetchImageWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = [NSString stringWithFormat:@"image?id=%@&redirect=1", identifier];
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:identifier, @"identifier", userInfo, @"userInfo", nil];
	[self sendRequestWithPath:path identifier:@"image" action:@selector(didFetchImage:data:) failedAction:@selector(didFailedFetchImage:error:) delegate:delegate userInfo:info];		
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
}
	
	
@end
