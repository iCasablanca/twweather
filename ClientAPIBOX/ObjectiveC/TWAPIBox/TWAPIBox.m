//
//  TWAPIBox.m
//  Created by zonble on 2009/07/31.
//

#import "TWAPIBox.h"

static TWAPIBox *apibox;

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
	[_request release];
	[super dealloc];
}

- (id)init
{
	self = [super init];
    if (self) {
		_request = [[LFHTTPRequest alloc] init];
		[_request setDelegate:self];
    }
    return self;
}

- (void)fetchOverviewWithFormat:(TWOverviewFormat)format delegate:(id)delegate userInfo:(id)userInfo
{
}
- (void)fetchForecastWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
}
- (void)fetchWeekWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
}
- (void)fetchWeekTravelWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
}
- (void)fetchThreeDaySeaWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
}
- (void)fetchNearSeaWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
}
- (void)fetchTideWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
}
- (void)fetchImageWithLocationIdentifier:(NSString *)identifier delegate:(id)delegate userInfo:(id)userInfo
{
}


@end
