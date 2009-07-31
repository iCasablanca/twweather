//
//  TWAPIBox+Info.h
//  Created by zonble on 2009/07/31.

#import <Foundation/Foundation.h>
#import "TWAPIBox.h"

@interface TWAPIBox(Info)

- (void)initInfoArrays;
- (void)releaseInfoArrays;

- (NSArray *)forecastLocations;
- (NSArray *)weekLocations;
- (NSArray *)weekTravelLocations;
- (NSArray *)threeDaySeaLocations;
- (NSArray *)nearSeaLocations;
- (NSArray *)tideLocations;
- (NSArray *)imageIdentifiers;

@end
