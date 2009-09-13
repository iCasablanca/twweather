//
// TWAPIBox+Cache.m
//
// Copyright (c) 2009 Weizhong Yang (http://zonble.net)
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import "TWAPIBox+Cache.h"
#import "CocoaCryptoHashing.h"

@implementation TWAPIBox(Cache)

- (NSString *)cacheFolderPath
{
	
#ifdef WIDGET
	NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *docPath = [docPaths objectAtIndex:0];
	NSString *cachePath = [docPath stringByAppendingPathComponent:@"net.zonble.twweather.widget"];	
#else
	NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath = [docPaths objectAtIndex:0];
	NSString *cachePath = [docPath stringByAppendingPathComponent:@"cache"];	
#endif
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
