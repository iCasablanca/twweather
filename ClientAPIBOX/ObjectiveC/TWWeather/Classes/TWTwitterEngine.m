//
// TWTwitterEngine.m
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
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "TWTwitterEngine.h"
#import "TWWeatherAppDelegate.h"

static TWTwitterEngine* sharedEngine;

@implementation TWTwitterEngine

+ (TWTwitterEngine *)sharedEngine
{
	if (!sharedEngine) {
		sharedEngine = [[TWTwitterEngine alloc] init];
	}
	return sharedEngine;
}

- (void) dealloc
{
	delegate = nil;
	[engine release];
	[super dealloc];
}

- (id)init
{
	self = [super init];
	if (self != nil) {
		delegate = nil;
		engine = [[MGTwitterEngine alloc] initWithDelegate:self];
		NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
		NSString *clientName = [infoDictionary objectForKey:@"CFBundleName"];
		NSString *version = [infoDictionary objectForKey:@"CFBundleVersion"];	
		[engine setClientName:clientName version:version URL:@"http://zonble.net" token:@"twweather"];			
	}
	return self;
}

#pragma mark -

#pragma mark -

- (void)requestSucceeded:(NSString *)requestIdentifier
{
	if (delegate && [delegate respondsToSelector:@selector(requestSucceeded:)]) {
		[(NSObject<MGTwitterEngineDelegate> *)delegate requestSucceeded:requestIdentifier];
	}
}
- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error
{
	if (delegate && [delegate respondsToSelector:@selector(requestFailed:withError:)]) {
		[(NSObject<MGTwitterEngineDelegate> *)delegate requestFailed:requestIdentifier withError:error];
	}
}
- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)identifier
{
	if (delegate && [delegate respondsToSelector:@selector(statusesReceived:forRequest:)]) {
		[(NSObject<MGTwitterEngineDelegate> *)delegate statusesReceived:statuses forRequest:identifier];
	}	
}
- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)identifier
{
	if (delegate && [delegate respondsToSelector:@selector(directMessagesReceived:forRequest:)]) {
		[(NSObject<MGTwitterEngineDelegate> *)delegate directMessagesReceived:messages forRequest:identifier];
	}	
}
- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)identifier
{
	if (delegate && [delegate respondsToSelector:@selector(userInfoReceived:forRequest:)]) {
		[(NSObject<MGTwitterEngineDelegate> *)delegate userInfoReceived:userInfo forRequest:identifier];
	}	
}
- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)identifier
{
	if (delegate && [delegate respondsToSelector:@selector(miscInfoReceived:forRequest:)]) {
		[(NSObject<MGTwitterEngineDelegate> *)delegate miscInfoReceived:miscInfo forRequest:identifier];
	}	
}
- (void)imageReceived:(UIImage *)image forRequest:(NSString *)identifier
{
	if (delegate && [delegate respondsToSelector:@selector(imageReceived:forRequest:)]) {
		[(NSObject<MGTwitterEngineDelegate> *)delegate imageReceived:image forRequest:identifier];
	}	
}


#pragma mark -

- (void)setLoggedIn:(BOOL)flag
{
	isLoggedIn = flag;
}
- (BOOL)isLoggedIn
{
	return isLoggedIn;
}

@synthesize delegate;
@synthesize engine;
@dynamic loggedIn;

@end
