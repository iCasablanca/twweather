//
//  TWAPITest.m
//

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
	NSArray *items = [d objectForKey:@"items"];
	STAssertTrue([items isKindOfClass:[NSArray class]], @"The items array is not an NSArray object!");
	STAssertTrue([items count] == 3, @"The coount of the items array is not correct! [items count]  = %d", [items count]);
	NSDictionary *dictionary = nil;
	NSEnumerator *enumerator = [items objectEnumerator];
	while (dictionary = [enumerator nextObject]) {
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




@end
