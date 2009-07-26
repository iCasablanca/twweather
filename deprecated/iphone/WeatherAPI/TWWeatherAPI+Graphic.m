//
//  TWWeatherAPI+Graphic.m
//  TWWeather
//
//  Created by zonble on 2009/1/17.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "TWWeatherAPI+Graphic.h"

@implementation TWWeatherAPI(Graphic)

- (void)loadImage:(UIImage *)image delegate:(id)delegate name:(NSString *)name
{
	if (delegate && [delegate respondsToSelector:@selector(graphicDidComplete:image:name:)])
		[delegate graphicDidComplete:self image:image name:name];
}

- (void)fetchGraphicWithDelegate:(id)delegate name: (NSString *)name URLString:(NSString *)URLString
{
	if ([_request isRunning])
		[_request cancel];
	
	NSURL *URL = [NSURL URLWithString:URLString];
	ZBSessionInfo *info = [ZBSessionInfo info];
	info.URL = URL;
	info.type = zGraphicType;
	info.name = name;
	info.delegate = delegate;
	_request.sessionInfo = info;
	
	UIImage *image  = nil;
	NSString *path = [ZBFileCache cachePathForURL:URL];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSDate *fileModDate;
		NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:path traverseLink:YES];
		if (fileModDate = [fileAttributes objectForKey:NSFileModificationDate]) {
			image = [UIImage imageWithContentsOfFile:path];
			if (image && [fileModDate timeIntervalSinceNow] > -60.0 * 5) {
				[self loadImage:image delegate:delegate name:name];
			}
		}
	}
	
	if ([[Reachability sharedReachability] remoteHostStatus] != NotReachable) {
		[_request performMethod:LFHTTPRequestGETMethod onURL:URL withData:nil];
		return;
	}
	
	if (image) {
		[self loadImage:image delegate:delegate name:name];
	}
	else {
		if (delegate && [delegate respondsToSelector:@selector(graphicDidFail:)])
			[delegate graphicDidFail:self];	
	}
}


@end
