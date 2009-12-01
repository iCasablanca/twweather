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
		NSString *identifier = [d objectForKey:@"identifier"];
		[[TWAPIBox sharedBox] fetchForecastWithLocationIdentifier:identifier delegate:self userInfo:identifier];
	}
}
- (void)testWeek
{
	NSArray *locations = [[TWAPIBox sharedBox] weekLocations];
	NSDictionary *d = nil;
	NSEnumerator *e = [locations objectEnumerator];
	while (d = [e nextObject]) {		
		NSString *identifier = [d objectForKey:@"identifier"];
		[[TWAPIBox sharedBox] fetchWeekWithLocationIdentifier:identifier delegate:self userInfo:identifier];
	}
}
- (void)testWeekTravel
{
	NSArray *locations = [[TWAPIBox sharedBox] weekTravelLocations];
	NSDictionary *d = nil;
	NSEnumerator *e = [locations objectEnumerator];
	while (d = [e nextObject]) {		
		NSString *identifier = [d objectForKey:@"identifier"];
		[[TWAPIBox sharedBox] fetchWeekTravelWithLocationIdentifier:identifier delegate:self userInfo:identifier];
	}
}
- (void)testThreeDaySee
{
	NSArray *locations = [[TWAPIBox sharedBox] threeDaySeaLocations];
	NSDictionary *d = nil;
	NSEnumerator *e = [locations objectEnumerator];
	while (d = [e nextObject]) {		
		NSString *identifier = [d objectForKey:@"identifier"];
		[[TWAPIBox sharedBox] fetchThreeDaySeaWithLocationIdentifier:identifier delegate:self userInfo:identifier];
	}
}
- (void)testNearSee
{
	NSArray *locations = [[TWAPIBox sharedBox] nearSeaLocations];
	NSDictionary *d = nil;
	NSEnumerator *e = [locations objectEnumerator];
	while (d = [e nextObject]) {		
		NSString *identifier = [d objectForKey:@"identifier"];
		[[TWAPIBox sharedBox] fetchNearSeaWithLocationIdentifier:identifier delegate:self userInfo:identifier];
	}
}
- (void)testTide
{
	NSArray *locations = [[TWAPIBox sharedBox] tideLocations];
	NSDictionary *d = nil;
	NSEnumerator *e = [locations objectEnumerator];
	while (d = [e nextObject]) {		
		NSString *identifier = [d objectForKey:@"identifier"];
		[[TWAPIBox sharedBox] fetchTideWithLocationIdentifier:identifier delegate:self userInfo:identifier];
	}
}

#pragma mark -

- (void)APIBox:(TWAPIBox *)APIBox didFetchWarnings:(id)result userInfo:(id)userInfo
{
	STAssertNotNil(result, @"The warnings array should not be nil!");
	STAssertTrue([result isKindOfClass:[NSArray class]], @"The warnings array should be an NSArray object!");
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWarningsWithError:(NSError *)error
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchOverview:(NSString *)string userInfo:(id)userInfo
{
	STAssertNotNil(string, @"The overview text should not be nil!");
	STAssertTrue([string isKindOfClass:[NSString class]], @"The overview text should be an NSString object!");
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchOverviewWithError:(NSError *)error
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}

- (void)APIBox:(TWAPIBox *)APIBox didFetchAllForecasts:(id)result userInfo:(id)userInfo
{
	STAssertNotNil(result, @"The forecasts array should not be nil!");
	STAssertTrue([result isKindOfClass:[NSArray class]], @"The all forecasts array should be an NSArray object!");
	STAssertTrue([result count] == [[[TWAPIBox sharedBox] forecastLocations] count], @"Some forecasts are lost!");
	NSDictionary *d = nil;
	NSEnumerator *e = [(NSArray *)result objectEnumerator];
	while (d = [e nextObject]) {
		STAssertNotNil([d objectForKey:@"locationName"], @"The locationName object should not be nil!");
		STAssertNotNil([d objectForKey:@"id"], @"The id object should not be nil!");
		STAssertNotNil([d objectForKey:@"weekLocation"], @"The weekLocation object should not be nil!");
		STAssertNotNil([d objectForKey:@"items"], @"The items object should not be nil!");
		NSArray *items = [d objectForKey:@"items"];
		STAssertTrue([items isKindOfClass:[NSArray class]], @"The items array should be an NSArray object!");
		STAssertTrue([items count] == 3, @"The coount of the items array is not correct! [items count]  = %d", [items count]);
		NSDictionary *dictionary = nil;
		NSEnumerator *enumerator = [items objectEnumerator];
		while (dictionary = [enumerator nextObject]) {
			STAssertTrue([dictionary isKindOfClass:[NSDictionary class]], @"The item should be an NSDictionary object!");
			STAssertNotNil(dictionary, @"title object should not be nil!");
			STAssertNotNil([dictionary objectForKey:@"title"], @"title object should not be nil!");
			STAssertNotNil([dictionary objectForKey:@"time"], @"time object should not be nil!");
			STAssertNotNil([dictionary objectForKey:@"beginTime"], @"beginTime object should not be nil!");
			STAssertNotNil([dictionary objectForKey:@"endTime"], @"endTime object should not be nil!");
			STAssertNotNil([dictionary objectForKey:@"description"], @"description object should not be nil!");
			STAssertNotNil([dictionary objectForKey:@"temperature"], @"temperature object should not be nil!");
			STAssertNotNil([dictionary objectForKey:@"rain"], @"rain object should not be nil!");			
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
	STAssertNotNil([d objectForKey:@"locationName"], @"locationName object should not be nil!");
	STAssertNotNil([d objectForKey:@"id"], @"id object should not be nil!");
	STAssertNotNil([d objectForKey:@"weekLocation"], @"weekLocation object should not be nil!");
	STAssertNotNil([d objectForKey:@"items"], @"items object object should not be nil!");
	NSArray *items = [d objectForKey:@"items"];
	STAssertTrue([items isKindOfClass:[NSArray class]], @"The items array should be an NSArray object!");
	STAssertTrue([items count] == 3, @"The coount of the items array is not correct! [items count]  = %d", [items count]);
	NSDictionary *dictionary = nil;
	NSEnumerator *enumerator = [items objectEnumerator];
	while (dictionary = [enumerator nextObject]) {
		STAssertTrue([dictionary isKindOfClass:[NSDictionary class]], @"The item should be an NSDictionary object!");
		STAssertNotNil(dictionary, @"title object should not be nil!");
		STAssertNotNil([dictionary objectForKey:@"title"], @"title object should not be nil!");
		STAssertNotNil([dictionary objectForKey:@"time"], @"time object should not be nil!");
		STAssertNotNil([dictionary objectForKey:@"beginTime"], @"beginTime object should not be nil!");
		STAssertNotNil([dictionary objectForKey:@"endTime"], @"endTime object should not be nil!");
		STAssertNotNil([dictionary objectForKey:@"description"], @"description object should not be nil!");
		STAssertNotNil([dictionary objectForKey:@"temperature"], @"temperature object should not be nil!");
		STAssertNotNil([dictionary objectForKey:@"rain"], @"rain object should not be nil!");			
	}
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchForecastWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}
- (void)APIBox:(TWAPIBox *)APIBox didFetchWeek:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	NSDictionary *d = (NSDictionary *)result;
	STAssertTrue([d isKindOfClass:[NSDictionary class]], @"The item should be an NSDictionary object!");
	STAssertNotNil([d objectForKey:@"locationName"], @"locationName object should not be nil!");
	STAssertNotNil([d objectForKey:@"id"], @"id object should not be nil!");
	STAssertNotNil([d objectForKey:@"publishTime"], @"publishTime object should not be nil!");
	STAssertNotNil([d objectForKey:@"items"], @"items object object should not be nil!");
	NSArray *items = [d objectForKey:@"items"];
	STAssertTrue([items count] == 7, @"The coount of the items array is not correct! [items count]  = %d", [items count]);
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWeekWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}
- (void)APIBox:(TWAPIBox *)APIBox didFetchWeekTravel:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	NSDictionary *d = (NSDictionary *)result;
	STAssertTrue([d isKindOfClass:[NSDictionary class]], @"The item should be an NSDictionary object!");
	STAssertNotNil([d objectForKey:@"locationName"], @"locationName object should not be nil!");
	STAssertNotNil([d objectForKey:@"id"], @"id object should not be nil!");
	STAssertNotNil([d objectForKey:@"publishTime"], @"publishTime object should not be nil!");
	STAssertNotNil([d objectForKey:@"items"], @"items object object should not be nil!");
	NSArray *items = [d objectForKey:@"items"];
	STAssertTrue([items count] == 7, @"The coount of the items array is not correct! [items count]  = %d", [items count]);	
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWeekTravelWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}
- (void)APIBox:(TWAPIBox *)APIBox didFetchThreeDaySea:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	NSDictionary *d = (NSDictionary *)result;
	STAssertTrue([d isKindOfClass:[NSDictionary class]], @"The item should be an NSDictionary object!");
	STAssertNotNil([d objectForKey:@"locationName"], @"locationName object should not be nil!");
	STAssertNotNil([d objectForKey:@"id"], @"id object should not be nil!");
	STAssertNotNil([d objectForKey:@"publishTime"], @"publishTime object should not be nil!");
	STAssertNotNil([d objectForKey:@"items"], @"items object object should not be nil!");
	NSArray *items = [d objectForKey:@"items"];
	STAssertTrue([items count] == 3, @"The coount of the items array is not correct! [items count]  = %d", [items count]);	
	NSDictionary *dictionary = nil;
	NSEnumerator *enumerator = [items objectEnumerator];
	while (dictionary = [enumerator nextObject]) {
		STAssertNotNil([dictionary objectForKey:@"date"], @"date object should not be nil!");
		STAssertNotNil([dictionary objectForKey:@"description"], @"description object should not be nil!");
		STAssertNotNil([dictionary objectForKey:@"wave"], @"wave object should not be nil!");
		STAssertNotNil([dictionary objectForKey:@"wind"], @"wind object should not be nil!");
		STAssertNotNil([dictionary objectForKey:@"windScale"], @"windScale object should not be nil!");
	}
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchThreeDaySeaWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}
- (void)APIBox:(TWAPIBox *)APIBox didFetchNearSea:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	NSDictionary *d = (NSDictionary *)result;
	STAssertTrue([d isKindOfClass:[NSDictionary class]], @"The item should be an NSDictionary object!");
	STAssertNotNil([d objectForKey:@"locationName"], @"locationName object should not be nil!");
	STAssertNotNil([d objectForKey:@"id"], @"id object should not be nil!");
	STAssertNotNil([d objectForKey:@"description"], @"description object should not be nil!");
	STAssertNotNil([d objectForKey:@"publishTime"], @"publishTime object should not be nil!");	
	STAssertNotNil([d objectForKey:@"validBeginTime"], @"validBeginTime object should not be nil!");
	STAssertNotNil([d objectForKey:@"validEndTime"], @"validEndTime object should not be nil!");
	STAssertNotNil([d objectForKey:@"validTime"], @"validTime ");
	STAssertNotNil([d objectForKey:@"wave"], @"wave object should not be nil!");
	STAssertNotNil([d objectForKey:@"waveLevel"], @"waveLevel object should not be nil!");
	STAssertNotNil([d objectForKey:@"wind"], @"wind object should not be nil!");
	STAssertNotNil([d objectForKey:@"windScale"], @"windScale object should not be nil!");
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchNearSeaWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}
- (void)APIBox:(TWAPIBox *)APIBox didFetchTide:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	NSDictionary *d = (NSDictionary *)result;
	STAssertTrue([d isKindOfClass:[NSDictionary class]], @"The item should be an NSDictionary object!");
	STAssertNotNil([d objectForKey:@"locationName"], @"locationName object should not be nil!");
	STAssertNotNil([d objectForKey:@"id"], @"id object should not be nil!");
	STAssertNotNil([d objectForKey:@"publishTime"], @"publishTime object should not be nil!");
	STAssertNotNil([d objectForKey:@"items"], @"items object object should not be nil!");
	NSArray *items = [d objectForKey:@"items"];
	STAssertTrue([items count] == 3, @"The coount of the items array is not correct! [items count]  = %d", [items count]);	
	NSDictionary *dictionary = nil;
	NSEnumerator *enumerator = [items objectEnumerator];
	while (dictionary = [enumerator nextObject]) {
		STAssertNotNil([dictionary objectForKey:@"date"], @"date object should not be nil!");
		STAssertNotNil([dictionary objectForKey:@"lunarDate"], @"lunarDate object should not be nil!");
		STAssertNotNil([dictionary objectForKey:@"high"], @"high object should not be nil!");
		NSDictionary *high = [dictionary objectForKey:@"high"];
		STAssertNotNil([high objectForKey:@"height"], @"height object should not be nil!");
		STAssertNotNil([high objectForKey:@"longTime"], @"longTime object should not be nil!");
		STAssertNotNil([high objectForKey:@"shortTime"], @"shortTime object should not be nil!");
		STAssertNotNil([dictionary objectForKey:@"low"], @"low object should not be nil!");
		NSDictionary *low = [dictionary objectForKey:@"low"];
		STAssertNotNil([low objectForKey:@"height"], @"height object should not be nil!");
		STAssertNotNil([low objectForKey:@"longTime"], @"longTime object should not be nil!");
		STAssertNotNil([low objectForKey:@"shortTime"], @"shortTime object should not be nil!");		
	}
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchTideWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}




@end
