//
// TWAPIBox.h
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

#import <Foundation/Foundation.h>
#import "LFHTTPRequest.h"

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

- (void)APIBox:(TWAPIBox *)APIBox didFetchOverview:(NSString *)string userInfo:(id)userInfo;
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchOverviewWithError:(NSError *)error;

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

@end

@interface TWAPIBox : NSObject 
{
	LFHTTPRequest *_request;
	NSMutableArray *_forecastLocations;
	NSMutableArray *_weekLocations;
	NSMutableArray *_weekTravelLocations;
	NSMutableArray *_threeDaySeaLocations;
	NSMutableArray *_nearSeaLocations;
	NSMutableArray *_tideLocations;
	NSMutableArray *_imageIdentifiers;
	NSDateFormatter *_formatter;
}

+ (TWAPIBox *)sharedBox;
- (void)fetchOverviewWithFormat:(TWOverviewFormat)format delegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchForecastWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchWeekWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchWeekTravelWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchThreeDaySeaWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchNearSeaWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchTideWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo;
- (void)fetchImageWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo;

- (NSDate *)dateFromString:(NSString *)string;
- (NSDate *)dateFromShortString:(NSString *)string;
- (NSString *)shortDateTimeStringFromDate:(NSDate *)date;
- (NSString *)shortDateStringFromDate:(NSDate *)date;

@end
