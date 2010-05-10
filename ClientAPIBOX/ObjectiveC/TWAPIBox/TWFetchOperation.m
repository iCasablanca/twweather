//
// TWFetchOperation.m
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

#import "TWFetchOperation.h"


@implementation TWFetchOperation

- (void)dealloc
{
	[sessionInfo release];
	[_request release];
	[_reachability release];
	[super dealloc];
}

- (id)initWithDelegate:(id)newDelegate sessionInfo:(id)newSessionInfo;
{
	self = [super init];
	if (self != nil) {
		delegate = newDelegate;
		sessionInfo = [newSessionInfo retain];

		_reachability = [[LFSiteReachability alloc] init];
		_reachability.siteURL = [NSURL URLWithString:BASE_URL_STRING];
		_reachability.timeoutInterval = 5.0;
		_reachability.delegate = self;

		_request = [[LFHTTPRequest alloc] init];
		_request.timeoutInterval = 5.0;
		_request.sessionInfo = sessionInfo;
		_request.delegate = self;
	}
	return self;
}

- (void)cancel
{
    [super cancel];	
    runloopRunning = NO;
}

- (BOOL)isConcurrent
{
	return YES;
}

- (void)main 
{
	@try {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		[_reachability startChecking];
		runloopRunning = YES;
		while (runloopRunning) {
			[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:5.0]];
		}
		[pool release];
	}
	@catch(...) {
		[delegate httpRequestDidCancel:_request];
	}
}

#pragma mark -

- (void)httpRequestDidComplete:(LFHTTPRequest *)request
{
	NSData *data = [request receivedData];
	if (![data length] && !_retryCount) {
		_retryCount++;
		NSURL *URL = [request.sessionInfo objectForKey:@"URL"];	
		[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];		
		return;
	}
	[delegate httpRequestDidComplete:request];
    runloopRunning = NO;
}
- (void)httpRequestDidCancel:(LFHTTPRequest *)request
{
	[delegate httpRequestDidCancel:request];
    runloopRunning = NO;
}
- (void)httpRequest:(LFHTTPRequest *)request didFailWithError:(NSString *)error
{
	if (!_retryCount) {
		_retryCount++;
		NSURL *URL = [request.sessionInfo objectForKey:@"URL"];	
		[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];		
		return;		
	}
	[delegate httpRequest:request didFailWithError:error];
    runloopRunning = NO;
}


#pragma mark -

- (void)reachability:(LFSiteReachability *)inReachability site:(NSURL *)inURL isAvailableOverConnectionType:(NSString *)inConnectionType
{
	NSURL *URL = [sessionInfo objectForKey:@"URL"];
	[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];	
	[inReachability stopChecking];
	
}
- (void)reachability:(LFSiteReachability *)inReachability siteIsNotAvailable:(NSURL *)inURL
{
	[delegate httpRequest:_request didFailWithError:LFHTTPRequestConnectionError];
	[inReachability stopChecking];
    runloopRunning = NO;
}


@synthesize sessionInfo;

@end
