//
//  ZBFileCache.h
//  TWWeather
//
//  Created by zonble on 2009/1/12.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZBFileCache : NSObject

+ (NSString *)cacheFolderPath;
+ (NSString *)cachePathForURL:(NSURL *)URL;

@end
