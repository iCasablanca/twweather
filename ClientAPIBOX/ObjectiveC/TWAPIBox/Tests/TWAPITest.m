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
		STAssertNotNil([d valueForKey:@"locationName"], @"The locationName object should not be nil!");
		STAssertNotNil([d valueForKey:@"id"], @"The id object should not be nil!");
		STAssertNotNil([d valueForKey:@"weekLocation"], @"The weekLocation object should not be nil!");
		STAssertNotNil([d valueForKey:@"items"], @"The items object should not be nil!");
		NSArray *items = [d valueForKey:@"items"];
		STAssertTrue([items isKindOfClass:[NSArray class]], @"The items array should be an NSArray object!");
		STAssertTrue([items count] == 3, @"The coount of the items array is not correct! [items count]  = %d", [items count]);
		NSDictionary *dictionary = nil;
		NSEnumerator *enumerator = [items objectEnumerator];
		while (dictionary = [enumerator nextObject]) {
			STAssertTrue([dictionary isKindOfClass:[NSDictionary class]], @"The item should be an NSDictionary object!");
			STAssertNotNil(dictionary, @"title object should not be nil!");
			STAssertNotNil([dictionary valueForKey:@"title"], @"title object should not be nil!");
			STAssertNotNil([dictionary valueForKey:@"time"], @"time object should not be nil!");
			STAssertNotNil([dictionary valueForKey:@"beginTime"], @"beginTime object should not be nil!");
			STAssertNotNil([dictionary valueForKey:@"endTime"], @"endTime object should not be nil!");
			STAssertNotNil([dictionary valueForKey:@"description"], @"description object should not be nil!");
			STAssertNotNil([dictionary valueForKey:@"temperature"], @"temperature object should not be nil!");
			STAssertNotNil([dictionary valueForKey:@"rain"], @"rain object should not be nil!");			
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
	STAssertNotNil([d valueForKey:@"locationName"], @"locationName object should not be nil!");
	STAssertNotNil([d valueForKey:@"id"], @"id object should not be nil!");
	STAssertNotNil([d valueForKey:@"weekLocation"], @"weekLocation object should not be nil!");
	STAssertNotNil([d valueForKey:@"items"], @"items object object should not be nil!");
	NSArray *items = [d valueForKey:@"items"];
	STAssertTrue([items isKindOfClass:[NSArray class]], @"The items array should be an NSArray object!");
	STAssertTrue([items count] == 3, @"The coount of the items array is not correct! [items count]  = %d", [items count]);
	NSDictionary *dictionary = nil;
	NSEnumerator *enumerator = [items objectEnumerator];
	while (dictionary = [enumerator nextObject]) {
		STAssertTrue([dictionary isKindOfClass:[NSDictionary class]], @"The item should be an NSDictionary object!");
		STAssertNotNil(dictionary, @"title object should not be nil!");
		STAssertNotNil([dictionary valueForKey:@"title"], @"title object should not be nil!");
		STAssertNotNil([dictionary valueForKey:@"time"], @"time object should not be nil!");
		STAssertNotNil([dictionary valueForKey:@"beginTime"], @"beginTime object should not be nil!");
		STAssertNotNil([dictionary valueForKey:@"endTime"], @"endTime object should not be nil!");
		STAssertNotNil([dictionary valueForKey:@"description"], @"description object should not be nil!");
		STAssertNotNil([dictionary valueForKey:@"temperature"], @"temperature object should not be nil!");
		STAssertNotNil([dictionary valueForKey:@"rain"], @"rain object should not be nil!");			
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
	STAssertNotNil([d valueForKey:@"locationName"], @"locationName object should not be nil!");
	STAssertNotNil([d valueForKey:@"id"], @"id object should not be nil!");
	STAssertNotNil([d valueForKey:@"publishTime"], @"publishTime object should not be nil!");
	STAssertNotNil([d valueForKey:@"items"], @"items object object should not be nil!");
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
	STAssertTrue([d isKindOfClass:[NSDictionary class]], @"The item should be an NSDictionary object!");
	STAssertNotNil([d valueForKey:@"locationName"], @"locationName object should not be nil!");
	STAssertNotNil([d valueForKey:@"id"], @"id object should not be nil!");
	STAssertNotNil([d valueForKey:@"publishTime"], @"publishTime object should not be nil!");
	STAssertNotNil([d valueForKey:@"items"], @"items object object should not be nil!");
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
	STAssertTrue([d isKindOfClass:[NSDictionary class]], @"The item should be an NSDictionary object!");
	STAssertNotNil([d valueForKey:@"locationName"], @"locationName object should not be nil!");
	STAssertNotNil([d valueForKey:@"id"], @"id object should not be nil!");
	STAssertNotNil([d valueForKey:@"publishTime"], @"publishTime object should not be nil!");
	STAssertNotNil([d valueForKey:@"items"], @"items object object should not be nil!");
	NSArray *items = [d valueForKey:@"items"];
	STAssertTrue([items count] == 3, @"The coount of the items array is not correct! [items count]  = %d", [items count]);	
	NSDictionary *dictionary = nil;
	NSEnumerator *enumerator = [items objectEnumerator];
	while (dictionary = [enumerator nextObject]) {
		STAssertNotNil([dictionary valueForKey:@"date"], @"date object should not be nil!");
		STAssertNotNil([dictionary valueForKey:@"description"], @"description object should not be nil!");
		STAssertNotNil([dictionary valueForKey:@"wave"], @"wave object should not be nil!");
		STAssertNotNil([dictionary valueForKey:@"wind"], @"wind object should not be nil!");
		STAssertNotNil([dictionary valueForKey:@"windScale"], @"windScale object should not be nil!");
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
	STAssertNotNil([d valueForKey:@"locationName"], @"locationName object should not be nil!");
	STAssertNotNil([d valueForKey:@"id"], @"id object should not be nil!");
	STAssertNotNil([d valueForKey:@"description"], @"description object should not be nil!");
	STAssertNotNil([d valueForKey:@"publishTime"], @"publishTime object should not be nil!");	
	STAssertNotNil([d valueForKey:@"validBeginTime"], @"validBeginTime object should not be nil!");
	STAssertNotNil([d valueForKey:@"validEndTime"], @"validEndTime object should not be nil!");
	STAssertNotNil([d valueForKey:@"validTime"], @"validTime ");
	STAssertNotNil([d valueForKey:@"wave"], @"wave object should not be nil!");
	STAssertNotNil([d valueForKey:@"waveLevel"], @"waveLevel object should not be nil!");
	STAssertNotNil([d valueForKey:@"wind"], @"wind object should not be nil!");
	STAssertNotNil([d valueForKey:@"windScale"], @"windScale object should not be nil!");
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchNearSeaWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}
- (void)APIBox:(TWAPIBox *)APIBox didFetchTide:(id)result identifier:(NSString *)identifier userInfo:(id)userInfo
{
	NSDictionary *d = (NSDictionary *)result;
	STAssertTrue([d isKindOfClass:[NSDictionary class]], @"The item should be an NSDictionary object!");
	STAssertNotNil([d valueForKey:@"locationName"], @"locationName object should not be nil!");
	STAssertNotNil([d valueForKey:@"id"], @"id object should not be nil!");
	STAssertNotNil([d valueForKey:@"publishTime"], @"publishTime object should not be nil!");
	STAssertNotNil([d valueForKey:@"items"], @"items object object should not be nil!");
	NSArray *items = [d valueForKey:@"items"];
	STAssertTrue([items count] == 3, @"The coount of the items array is not correct! [items count]  = %d", [items count]);	
	NSDictionary *dictionary = nil;
	NSEnumerator *enumerator = [items objectEnumerator];
	while (dictionary = [enumerator nextObject]) {
		STAssertNotNil([dictionary valueForKey:@"date"], @"date object should not be nil!");
		STAssertNotNil([dictionary valueForKey:@"lunarDate"], @"lunarDate object should not be nil!");
		STAssertNotNil([dictionary valueForKey:@"high"], @"high object should not be nil!");
		NSDictionary *high = [dictionary valueForKey:@"high"];
		STAssertNotNil([high valueForKey:@"height"], @"height object should not be nil!");
		STAssertNotNil([high valueForKey:@"longTime"], @"longTime object should not be nil!");
		STAssertNotNil([high valueForKey:@"shortTime"], @"shortTime object should not be nil!");
		STAssertNotNil([dictionary valueForKey:@"low"], @"low object should not be nil!");
		NSDictionary *low = [dictionary valueForKey:@"low"];
		STAssertNotNil([low valueForKey:@"height"], @"height object should not be nil!");
		STAssertNotNil([low valueForKey:@"longTime"], @"longTime object should not be nil!");
		STAssertNotNil([low valueForKey:@"shortTime"], @"shortTime object should not be nil!");		
	}
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchTideWithError:(NSError *)error identifier:(NSString *)identifier userInfo:(id)userInfo
{
	STFail(@"%s, %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}




@end
