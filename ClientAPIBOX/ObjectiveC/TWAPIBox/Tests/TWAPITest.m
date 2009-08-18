#import "TWAPITest.h"

@implementation TWAPITest

- (void)testAPI
{
	TWAPIBox *box = [TWAPIBox sharedBox];
	[box setShouldWaitUntilDone:YES];
	[box fetchWarningsWithDelegate:self	userInfo:nil];
	[box fetchOverviewWithFormat:TWOverviewPlainFormat delegate:self userInfo:nil];
	[box fetchAllForecastsWithDelegate:self userInfo:nil];
}
- (void)testForecasts
{
	NSArray *locations = [[TWAPIBox sharedBox] forecastLocations];
	NSDictionary *d = nil;
	NSEnumerator *e = [locations objectEnumerator];
	while (d = [e nextObject]) {		
		NSString *identifier = [d valueForKey:@"identifier"];
		[[TWAPIBox sharedBox] fetchForecastWithLocationIdentifier:identifier delegate:self userInfo:identifier];
	}
}
- (void)testWeek
{
	NSArray *locations = [[TWAPIBox sharedBox] weekLocations];
	NSDictionary *d = nil;
	NSEnumerator *e = [locations objectEnumerator];
	while (d = [e nextObject]) {		
		NSString *identifier = [d valueForKey:@"identifier"];
		[[TWAPIBox sharedBox] fetchWeekWithLocationIdentifier:identifier delegate:self userInfo:identifier];
	}
}
- (void)testWeekTravel
{
	NSArray *locations = [[TWAPIBox sharedBox] weekTravelLocations];
	NSDictionary *d = nil;
	NSEnumerator *e = [locations objectEnumerator];
	while (d = [e nextObject]) {		
		NSString *identifier = [d valueForKey:@"identifier"];
		[[TWAPIBox sharedBox] fetchWeekTravelWithLocationIdentifier:identifier delegate:self userInfo:identifier];
	}
}
- (void)testThreeDaySee
{
	NSArray *locations = [[TWAPIBox sharedBox] threeDaySeaLocations];
	NSDictionary *d = nil;
	NSEnumerator *e = [locations objectEnumerator];
	while (d = [e nextObject]) {		
		NSString *identifier = [d valueForKey:@"identifier"];
		[[TWAPIBox sharedBox] fetchThreeDaySeaWithLocationIdentifier:identifier delegate:self userInfo:identifier];
	}
}
- (void)testNearSee
{
	NSArray *locations = [[TWAPIBox sharedBox] nearSeaLocations];
	NSDictionary *d = nil;
	NSEnumerator *e = [locations objectEnumerator];
	while (d = [e nextObject]) {		
		NSString *identifier = [d valueForKey:@"identifier"];
		[[TWAPIBox sharedBox] fetchNearSeaWithLocationIdentifier:identifier delegate:self userInfo:identifier];
	}
}
- (void)testTide
{
	NSArray *locations = [[TWAPIBox sharedBox] tideLocations];
	NSDictionary *d = nil;
	NSEnumerator *e = [locations objectEnumerator];
	while (d = [e nextObject]) {		
		NSString *identifier = [d valueForKey:@"identifier"];
		[[TWAPIBox sharedBox] fetchTideWithLocationIdentifier:identifier delegate:self userInfo:identifier];
	}
}

#pragma mark -

- (void)APIBox:(TWAPIBox *)APIBox didFetchWarnings:(id)result userInfo:(id)userInfo
{
	STAssertNotNil(result, @"The Warnings array is nil!");
	STAssertTrue([result isKindOfClass:[NSArray class]], @"The Warnings array is not an NSArray object!");
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWarningsWithError:(NSError *)error
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchOverview:(NSString *)string userInfo:(id)userInfo
{
	STAssertNotNil(string, @"The Overview text is nil!");
	STAssertTrue([string isKindOfClass:[NSString class]], @"The Overview text is not an NSString object!");
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchOverviewWithError:(NSError *)error
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchAllForecasts:(id)result userInfo:(id)userInfo
{
	STAssertNotNil(result, @"The all forecasts array is nil!");
	STAssertTrue([result isKindOfClass:[NSArray class]], @"The all forecasts array is not an NSArray object!");
	STAssertTrue([result count] == [[[TWAPIBox sharedBox] forecastLocations] count], @"Some forecast are lost!");
	NSDictionary *d = nil;
	NSEnumerator *e = [(NSArray *)result objectEnumerator];
	while (d = [e nextObject]) {
		STAssertNotNil([d valueForKey:@"locationName"], @"locationName is nil!");
		STAssertNotNil([d valueForKey:@"id"], @"id is nil!");
		STAssertNotNil([d valueForKey:@"weekLocation"], @"weekLocation is nil!");
		STAssertNotNil([d valueForKey:@"items"], @"items object is nil!");
		NSArray *items = [d valueForKey:@"items"];
		STAssertTrue([items isKindOfClass:[NSArray class]], @"The items array is not an NSArray object!");
		STAssertTrue([items count] == 3, @"The coount of the items array is not correct! [items count]  = %d", [items count]);
		NSDictionary *dictionary = nil;
		NSEnumerator *enumerator = [items objectEnumerator];
		while (dictionary = [enumerator nextObject]) {
			STAssertTrue([dictionary isKindOfClass:[NSDictionary class]], @"The item is not an NSDictionary object!");
			STAssertNotNil(dictionary, @"title is nil!");
			STAssertNotNil([dictionary valueForKey:@"title"], @"title is nil!");
			STAssertNotNil([dictionary valueForKey:@"time"], @"time is nil!");
			STAssertNotNil([dictionary valueForKey:@"beginTime"], @"beginTime is nil!");
			STAssertNotNil([dictionary valueForKey:@"endTime"], @"endTime is nil!");
			STAssertNotNil([dictionary valueForKey:@"description"], @"description is nil!");
			STAssertNotNil([dictionary valueForKey:@"temperature"], @"temperature is nil!");
			STAssertNotNil([dictionary valueForKey:@"rain"], @"rain is nil!");			
		}
	}
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchAllForecastsWithError:(NSError *)error
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchForecast:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	NSDictionary *d = (NSDictionary *)result;
	STAssertNotNil([d valueForKey:@"locationName"], @"locationName is nil!");
	STAssertNotNil([d valueForKey:@"id"], @"id is nil!");
	STAssertNotNil([d valueForKey:@"weekLocation"], @"weekLocation is nil!");
	STAssertNotNil([d valueForKey:@"items"], @"items object is nil!");
	NSArray *items = [d valueForKey:@"items"];
	STAssertTrue([items isKindOfClass:[NSArray class]], @"The items array is not an NSArray object!");
	STAssertTrue([items count] == 3, @"The coount of the items array is not correct! [items count]  = %d", [items count]);
	NSDictionary *dictionary = nil;
	NSEnumerator *enumerator = [items objectEnumerator];
	while (dictionary = [enumerator nextObject]) {
		STAssertTrue([dictionary isKindOfClass:[NSDictionary class]], @"The item is not an NSDictionary object!");
		STAssertNotNil(dictionary, @"title is nil!");
		STAssertNotNil([dictionary valueForKey:@"title"], @"title is nil!");
		STAssertNotNil([dictionary valueForKey:@"time"], @"time is nil!");
		STAssertNotNil([dictionary valueForKey:@"beginTime"], @"beginTime is nil!");
		STAssertNotNil([dictionary valueForKey:@"endTime"], @"endTime is nil!");
		STAssertNotNil([dictionary valueForKey:@"description"], @"description is nil!");
		STAssertNotNil([dictionary valueForKey:@"temperature"], @"temperature is nil!");
		STAssertNotNil([dictionary valueForKey:@"rain"], @"rain is nil!");			
	}
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchForecastWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}
- (void)APIBox:(TWAPIBox *)APIBox didFetchWeek:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	NSDictionary *d = (NSDictionary *)result;
	STAssertTrue([d isKindOfClass:[NSDictionary class]], @"The item is not an NSDictionary object!");
	STAssertNotNil([d valueForKey:@"locationName"], @"locationName is nil!");
	STAssertNotNil([d valueForKey:@"id"], @"id is nil!");
	STAssertNotNil([d valueForKey:@"publishTime"], @"publishTime is nil!");
	STAssertNotNil([d valueForKey:@"items"], @"items object is nil!");
	NSArray *items = [d valueForKey:@"items"];
	STAssertTrue([items count] == 7, @"The coount of the items array is not correct! [items count]  = %d", [items count]);
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWeekWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}
- (void)APIBox:(TWAPIBox *)APIBox didFetchWeekTravel:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	NSDictionary *d = (NSDictionary *)result;
	STAssertTrue([d isKindOfClass:[NSDictionary class]], @"The item is not an NSDictionary object!");
	STAssertNotNil([d valueForKey:@"locationName"], @"locationName is nil!");
	STAssertNotNil([d valueForKey:@"id"], @"id is nil!");
	STAssertNotNil([d valueForKey:@"publishTime"], @"publishTime is nil!");
	STAssertNotNil([d valueForKey:@"items"], @"items object is nil!");
	NSArray *items = [d valueForKey:@"items"];
	STAssertTrue([items count] == 7, @"The coount of the items array is not correct! [items count]  = %d", [items count]);	
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWeekTravelWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}
- (void)APIBox:(TWAPIBox *)APIBox didFetchThreeDaySea:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	NSDictionary *d = (NSDictionary *)result;
	STAssertTrue([d isKindOfClass:[NSDictionary class]], @"The item is not an NSDictionary object!");
	STAssertNotNil([d valueForKey:@"locationName"], @"locationName is nil!");
	STAssertNotNil([d valueForKey:@"id"], @"id is nil!");
	STAssertNotNil([d valueForKey:@"publishTime"], @"publishTime is nil!");
	STAssertNotNil([d valueForKey:@"items"], @"items object is nil!");
	NSArray *items = [d valueForKey:@"items"];
	STAssertTrue([items count] == 3, @"The coount of the items array is not correct! [items count]  = %d", [items count]);	
	NSDictionary *dictionary = nil;
	NSEnumerator *enumerator = [items objectEnumerator];
	while (dictionary = [enumerator nextObject]) {
		STAssertNotNil([dictionary valueForKey:@"date"], @"date is nil!");
		STAssertNotNil([dictionary valueForKey:@"description"], @"description is nil!");
		STAssertNotNil([dictionary valueForKey:@"wave"], @"wave is nil!");
		STAssertNotNil([dictionary valueForKey:@"wind"], @"wind is nil!");
		STAssertNotNil([dictionary valueForKey:@"windScale"], @"windScale is nil!");
	}
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchThreeDaySeaWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}
- (void)APIBox:(TWAPIBox *)APIBox didFetchNearSea:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	NSDictionary *d = (NSDictionary *)result;
	STAssertTrue([d isKindOfClass:[NSDictionary class]], @"The item is not an NSDictionary object!");
	STAssertNotNil([d valueForKey:@"locationName"], @"locationName is nil!");
	STAssertNotNil([d valueForKey:@"id"], @"id is nil!");
	STAssertNotNil([d valueForKey:@"description"], @"description is nil!");
	STAssertNotNil([d valueForKey:@"publishTime"], @"publishTime is nil!");	
	STAssertNotNil([d valueForKey:@"validBeginTime"], @"validBeginTime is nil!");
	STAssertNotNil([d valueForKey:@"validEndTime"], @"validEndTime is nil!");
	STAssertNotNil([d valueForKey:@"validTime"], @"validTime is nil!");
	STAssertNotNil([d valueForKey:@"wave"], @"wave is nil!");
	STAssertNotNil([d valueForKey:@"waveLevel"], @"waveLevel is nil!");
	STAssertNotNil([d valueForKey:@"wind"], @"wind is nil!");
	STAssertNotNil([d valueForKey:@"windScale"], @"windScale is nil!");
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchNearSeaWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}
- (void)APIBox:(TWAPIBox *)APIBox didFetchTide:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	NSDictionary *d = (NSDictionary *)result;
	STAssertTrue([d isKindOfClass:[NSDictionary class]], @"The item is not an NSDictionary object!");
	STAssertNotNil([d valueForKey:@"locationName"], @"locationName is nil!");
	STAssertNotNil([d valueForKey:@"id"], @"id is nil!");
	STAssertNotNil([d valueForKey:@"publishTime"], @"publishTime is nil!");
	STAssertNotNil([d valueForKey:@"items"], @"items object is nil!");
	NSArray *items = [d valueForKey:@"items"];
	STAssertTrue([items count] == 3, @"The coount of the items array is not correct! [items count]  = %d", [items count]);	
	NSDictionary *dictionary = nil;
	NSEnumerator *enumerator = [items objectEnumerator];
	while (dictionary = [enumerator nextObject]) {
		STAssertNotNil([dictionary valueForKey:@"date"], @"date is nil!");
		STAssertNotNil([dictionary valueForKey:@"lunarDate"], @"lunarDate is nil!");
		STAssertNotNil([dictionary valueForKey:@"high"], @"high is nil!");
		NSDictionary *high = [dictionary valueForKey:@"high"];
		STAssertNotNil([high valueForKey:@"height"], @"height is nil!");
		STAssertNotNil([high valueForKey:@"longTime"], @"longTime is nil!");
		STAssertNotNil([high valueForKey:@"shortTime"], @"shortTime is nil!");
		STAssertNotNil([dictionary valueForKey:@"low"], @"low is nil!");
		NSDictionary *low = [dictionary valueForKey:@"low"];
		STAssertNotNil([low valueForKey:@"height"], @"height is nil!");
		STAssertNotNil([low valueForKey:@"longTime"], @"longTime is nil!");
		STAssertNotNil([low valueForKey:@"shortTime"], @"shortTime is nil!");		
	}
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchTideWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}




@end
