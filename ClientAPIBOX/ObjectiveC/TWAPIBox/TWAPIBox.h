//
// TWAPIBox.h
//
// Copyright (c) 2009 Weizhong Yang (http://zonble.net)
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

#import <Foundation/Foundation.h>
#import "LFHTTPRequest.h"
#import "LFSiteReachability.h"

typedef enum {
	TWOverviewHTMLFormat = 0,
	TWOverviewPlainFormat = 1
} TWOverviewFormat;

extern NSString *TWAPIErrorDomain;

typedef enum {
	TWAPIUnkownError = 0,
	TWAPIConnectionError = 1,
	TWAPITimeOutError = 2,
	TWAPIDataError = 3,
} TWAPIError;

@class TWAPIBox;

@interface NSObject(TWAPIBoxDelegate)

- (void)APIBox:(TWAPIBox *)APIBox didFetchWarnings:(id)result userInfo:(id)userInfo;
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWarningsWithError:(NSError *)error;

- (void)APIBox:(TWAPIBox *)APIBox didFetchOverview:(NSString *)string userInfo:(id)userInfo;
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchOverviewWithError:(NSError *)error;

- (void)APIBox:(TWAPIBox *)APIBox didFetchAllForecasts:(id)result userInfo:(id)userInfo;
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchAllForecastsWithError:(NSError *)error;

- (void)APIBox:(TWAPIBox *)APIBox didFetchForecast:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo;
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchForecastWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo;

- (void)APIBox:(TWAPIBox *)APIBox didFetchWeek:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo;
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWeekWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo;

- (void)APIBox:(TWAPIBox *)APIBox didFetchWeekTravel:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo;
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWeekTravelWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo;

- (void)APIBox:(TWAPIBox *)APIBox didFetchThreeDaySea:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo;
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchThreeDaySeaWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo;

- (void)APIBox:(TWAPIBox *)APIBox didFetchNearSea:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo;
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchNearSeaWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo;

- (void)APIBox:(TWAPIBox *)APIBox didFetchTide:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo;
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchTideWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo;

- (void)APIBox:(TWAPIBox *)APIBox didFetchImageData:(NSData *)data identifier:(NSString *)identifier userInfo:(id)userInfo;
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchImageWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo;

- (void)APIBox:(TWAPIBox *)APIBox didFetchOBS:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo;
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchOBSWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo;


@end

@interface TWAPIBox : NSObject <LFSiteReachabilityDelegate>
{
	LFHTTPRequest *_request;
	NSMutableArray *_queue;
	NSMutableArray *_forecastLocations;
	NSMutableArray *_weekLocations;
	NSMutableArray *_weekTravelLocations;
	NSMutableArray *_threeDaySeaLocations;
	NSMutableArray *_nearSeaLocations;
	NSMutableArray *_tideLocations;
	NSMutableArray *_imageIdentifiers;
	NSMutableArray *_OBSLocations;
	NSDateFormatter *_formatter;
	
	NSUInteger _retryCount;
	NSMutableDictionary *_retryCountDictionary;
	
	LFSiteReachability *_reachability;
	
	
	id _currentSessionInfo;
	NSURL *_currentURL;
}

+ (TWAPIBox *)sharedBox;
- (void)cancelAllRequest;
- (void)cancelAllRequestWithDelegate:(id)delegate;
- (void)runQueue;
- (void)fetchWarningsWithDelegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchOverviewWithFormat:(TWOverviewFormat)format delegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchAllForecastsWithDelegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchForecastWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchWeekWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchWeekTravelWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchThreeDaySeaWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchNearSeaWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchTideWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchImageWithIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchOBSWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo;
- (void)setShouldWaitUntilDone:(BOOL)flag;
- (BOOL)shouldWaitUntilDone;

- (NSURL *)imageURLFromIdentifier:(NSString *)identifier;

- (NSDate *)dateFromString:(NSString *)string;
- (NSDate *)dateFromShortString:(NSString *)string;
- (NSString *)shortDateTimeStringFromDate:(NSDate *)date;
- (NSString *)shortDateStringFromDate:(NSDate *)date;

@end
