//
//  ZBFileCache.m
//  TWWeather
//
//  Created by zonble on 2009/1/12.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "ZBFileCache.h"


@implementation ZBFileCache

+ (NSString *)cacheFolderPath
{
	NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath = [docPaths objectAtIndex:0];
	NSString *cachePath = [docPath stringByAppendingPathComponent:@"cache"];
	BOOL isDir = NO;
	if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:cachePath attributes:nil];
	}
	if (!isDir) {
		[[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
		[[NSFileManager defaultManager] createDirectoryAtPath:cachePath attributes:nil];
	}
	return cachePath;
}
+ (NSString *)cachePathForURL:(NSURL *)URL
{
	NSString *string = [URL absoluteString];
	string = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	string = [string stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	return [[ZBFileCache cacheFolderPath] stringByAppendingPathComponent:string];
}


@end
