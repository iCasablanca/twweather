//
// TWAPIBox+Private.m
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
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.OTHER DEALINGS IN THE SOFTWARE.
//

#import "TWAPIBox+Private.h"


@implementation TWAPIBox(Private)

#pragma mark -

- (NSDictionary *)_errorDictionaryWithCode:(int)code
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	if (code == TWAPIConnectionError) {
		[dictionary setObject:NSLocalizedString(@"Connection Error. Unable to connect to the remote server, please try again.", @"") forKey:NSLocalizedDescriptionKey];
	}
	else if (code == TWAPITimeOutError) {
		[dictionary setObject:NSLocalizedString(@"Connection Time Out. Unable to connect to the remote server, please try again.", @"") forKey:NSLocalizedDescriptionKey];
	}
	else if (code == TWAPIDataError) {
		[dictionary setObject:NSLocalizedString(@"Data Error. Unable to parse the data from the remote server, please contact me to fix the server.", @"") forKey:NSLocalizedDescriptionKey];
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
