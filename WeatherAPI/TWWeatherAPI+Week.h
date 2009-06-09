//
//  TWWeatherAPI+Week.h
//  TWWeather
//
//  Created by zonble on 2009/1/17.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWWeatherAPI.h"

@interface TWWeatherAPI(Week)
- (void)parseWeekString:(NSString *)string delegate:(id)delegate name:(NSString *)name;
- (void)fetchWeekWithDelegate:(id)delegate name:(NSString *)name URLString:(NSString *)URLString;
@end
