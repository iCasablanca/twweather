//
//  TWWeatherAPI+OverViewParser.h
//  TWWeather
//
//  Created by zonble on 2009/1/17.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWWeatherAPI.h"

@interface TWWeatherAPI(OverViewParser)
- (void)parseOverviewString:(NSString *)string delegate:(id)delegate;
- (void)fetchOverviewWithDelegate:(id)delegate;
@end

