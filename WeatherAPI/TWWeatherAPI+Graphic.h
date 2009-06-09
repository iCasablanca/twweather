//
//  TWWeatherAPI+Graphic.h
//  TWWeather
//
//  Created by zonble on 2009/1/17.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWWeatherAPI.h"

@interface TWWeatherAPI(Graphic)
- (void)loadImage:(UIImage *)image delegate:(id)delegate name:(NSString *)name;
- (void)fetchGraphicWithDelegate:(id)delegate name: (NSString *)name URLString:(NSString *)URLString;
@end
