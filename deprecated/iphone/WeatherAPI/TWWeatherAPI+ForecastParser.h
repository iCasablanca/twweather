//
//  TWWeatherAPI+ForecastParser.h
//  TWWeather
//
//  Created by zonble on 2009/1/17.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWWeatherAPI.h"

@interface TWWeatherAPI(ForecastParser)
- (void)parseForecastString:(NSString *)string delegate:(id)delegate name:(NSString *)name;
- (void)fetchForecastWithDelegate:(id)delegate name:(NSString *)name URLString:(NSString *)URLString;
@end
