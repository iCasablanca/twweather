//
//  TWAPITest.m
//

#import "TWAPITest.h"

@implementation TWAPITest

- (void)testOverview
{
	TWAPIBox *box = [TWAPIBox sharedBox];
	[box setWaitUntilDone:YES];
	[box fetchOverviewWithFormat:TWOverviewPlainFormat delegate:self userInfo:nil];
}

#pragma mark -

- (void)APIBox:(TWAPIBox *)APIBox didFetchWarnings:(id)result userInfo:(id)userInfo
{
	NSLog(@"result:%@", [result description]);
}
- (void)APIBox:(TWAPIBox *)APIBox didFailedFetchWarningsWithError:(NSError *)error
{
	STFail([error localizedDescription]);
}


@end
