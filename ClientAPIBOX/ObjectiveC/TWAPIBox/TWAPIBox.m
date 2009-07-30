//
//  TWAPIBox.m
//  Created by zonble on 2009/07/31.
//

#import "TWAPIBox.h"

static TWAPIBox *apibox;

#define BASE_URL_STRING @"http://twweatherapi.appspot.com/"

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
	[_request cancelWithoutDelegateMessage];
	_request.delegate = nil;
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

- (void)didFetchOverview:(LFHTTPRequest *)request
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	NSData *data = [request receivedData];
	NSString *string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *sessionInfo = [request sessionInfo];
	id delegate = [sessionInfo objectForKey:@"delegate"];
	if (delegate && [delegate respondsToSelector:@selector(APIBox:didFetchOverview:userInfo:)]) {
		[delegate APIBox:self didFetchOverview:string userInfo:[sessionInfo objectForKey:@"userInfo"]];
	}
}
- (void)didFailedFetchOverview:(LFHTTPRequest *)request
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)sendRequestWithPath:(NSString *)path identifier:(NSString *)identifier  action:(SEL)action failedAction:(SEL)failedAction delegate:(id)delegate userInfo:(id)userInfo
{
	[_request cancelWithoutDelegateMessage];
	NSMutableDictionary *sessionInfo = [NSMutableDictionary dictionary];
	if (delegate)
		[sessionInfo setObject:delegate forKey:@"delegate"];
	if (userInfo)
		[sessionInfo setObject:userInfo forKey:@"userInfo"];
	if (identifier)
		[sessionInfo setObject:identifier forKey:@"identifier"];
	[sessionInfo setObject:NSStringFromSelector(action) forKey:@"action"];
	[sessionInfo setObject:NSStringFromSelector(failedAction) forKey:@"failedAction"];
	NSString *URLString = [BASE_URL_STRING stringByAppendingString:path];
	NSURL *URL = [NSURL URLWithString:URLString];
	_request.sessionInfo = sessionInfo;
	[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];
}

- (void)fetchOverviewWithFormat:(TWOverviewFormat)format delegate:(id)delegate userInfo:(id)userInfo
{
	NSString *path = @"overview";
	if (format == TWOverviewPlainFormat) {
		path = @"overview?output=plain";
	}
	[self sendRequestWithPath:path identifier:@"overview" action:@selector(didFetchOverview:) failedAction:@selector(didFailedFetchOverview:) delegate:delegate userInfo:userInfo];
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

- (void)httpRequestDidComplete:(LFHTTPRequest *)request
{
	NSString *actionString = [[request sessionInfo] objectForKey:@"action"];
	SEL action = NSSelectorFromString(actionString);
	[self performSelector:action withObject:request];
}
- (void)httpRequest:(LFHTTPRequest *)request didFailWithError:(NSString *)error;
{
	NSString *actionString = [[request sessionInfo] objectForKey:@"failedAction"];
	SEL action = NSSelectorFromString(actionString);
	[self performSelector:action withObject:request];
	
}
	
	
@end
