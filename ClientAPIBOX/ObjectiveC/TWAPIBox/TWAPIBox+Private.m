//
// TWAPIBox+Private.m
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

#import "TWAPIBox+Private.h"


@implementation TWAPIBox(Private)

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

- (void)didFetchWarning:(LFHTTPRequest *)request data:(NSData *)data
{
	NSPropertyListFormat format;
	NSString *error;
	id plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
	id result = [plist objectForKey:@"result"];
	
	NSDictionary *sessionInfo = [request sessionInfo];
	NSString *identifier = [sessionInfo objectForKey:@"identifier"];
	id delegate = [sessionInfo objectForKey:@"delegate"];
	if ([identifier isEqualToString:@"warning"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFetchWarnings:userInfo:)]) {
		[delegate APIBox:self didFetchWarnings:result userInfo:[sessionInfo objectForKey:@"userInfo"]];
	}
	else if ([identifier isEqualToString:@"forecastAll"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFetchAllForecasts:userInfo:)]) {
		[delegate APIBox:self didFetchAllForecasts:result userInfo:[sessionInfo objectForKey:@"userInfo"]];
	}
	
}
- (void)didFailedFetchWarning:(LFHTTPRequest *)request error:(NSString *)error
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
	NSString *identifier = [sessionInfo objectForKey:@"identifier"];	
	if ([identifier isEqualToString:@"warning"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchWarningsWithError:)]) {
		[delegate APIBox:self didFailedFetchWarningsWithError:theError];
	}	
	else if ([identifier isEqualToString:@"forecastAll"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchAllForecastsWithError:)]) {
		[delegate APIBox:self didFailedFetchAllForecastsWithError:theError];
	}	
	
}

- (void)didFetchOverview:(LFHTTPRequest *)request data:(NSData *)data
{
	NSString *string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
		else if ([identifier isEqualToString:@"obs"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFetchOBS:identifier:userInfo:)]) {
			[delegate APIBox:self didFetchOBS:result identifier:inIdentifier userInfo:userInfo];
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
		else if ([identifier isEqualToString:@"obs"] && delegate && [delegate respondsToSelector:@selector(APIBox:didFailedFetchOBSWithError:identifier:userInfo:)]) {
			[delegate APIBox:self didFailedFetchOBSWithError:theError identifier:inIdentifier userInfo:userInfo];
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

@end
