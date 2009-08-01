//
//  TWAPIBox+Cache.h
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import <Foundation/Foundation.h>
#import "TWAPIBox.h"

@interface TWAPIBox(Cache)

- (BOOL)shouldUseCachedDataForURL:(NSURL *)URL;
- (NSData *)dataInCacheForURL:(NSURL *)URL;
- (void)writeDataToCache:(NSData *)data fromURL:(NSURL *)URL;

@end
