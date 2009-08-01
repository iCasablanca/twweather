//
//  TWAPIBox+Cache.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWAPIBox+Cache.h"
#import "CocoaCryptoHashing.h"

@implementation TWAPIBox(Cache)

- (NSString *)cacheFolderPath
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

- (NSString *)md5HashPathForURLString:(NSString *)string
{
	NSString *md5Hash = [string md5HexHash];
	NSString *part = [md5Hash substringToIndex:5];
	NSString *folderPath = [[self cacheFolderPath] stringByAppendingPathComponent:part];
	BOOL isDir = NO;
	if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDir]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:folderPath attributes:nil];
	}
	if (!isDir) {
		[[NSFileManager defaultManager] removeItemAtPath:folderPath error:nil];
		[[NSFileManager defaultManager] createDirectoryAtPath:folderPath attributes:nil];
	}
	return [folderPath stringByAppendingPathComponent:md5Hash];
}

- (BOOL)shouldUseCachedDataForURL:(NSURL *)URL
{
	NSString *string = [URL absoluteString];
	NSString *path = [self md5HashPathForURLString:string];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSDate *fileModDate;
		NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:path traverseLink:YES];
		if (fileModDate = [fileAttributes objectForKey:NSFileModificationDate]) {
			if ([fileModDate timeIntervalSinceNow] > -60.0 * 10) {
				return YES;
			}
			return NO;
		}
	}
	return NO;
}

- (NSData *)dataInCacheForURL:(NSURL *)URL
{
	NSString *string = [URL absoluteString];
	NSString *path = [self md5HashPathForURLString:string];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSData *data = [NSData dataWithContentsOfFile:path];
		return data;
	}
	return nil;
}
- (void)writeDataToCache:(NSData *)data fromURL:(NSURL *)URL
{
	NSString *string = [URL absoluteString];
	NSString *path = [self md5HashPathForURLString:string];
	[data writeToFile:path atomically:YES];
}

@end
