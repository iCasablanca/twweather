//
//  TWWeatherAPI.h
//  TWWeather
//
//  Created by zonble on 2009/1/17.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFHTTPRequest.h"
#import "ZBFileCache.h"
#import "Reachability.h"

#define zOverviewType @"zOverviewType"
#define zForecastType @"zForecastType"
#define zGraphicType @"zGraphicType"
#define zWeekType @"zWeekType"

#define kTimeTitle @"kTimeTitle"
#define kTimeDate @"kTimeDate"
#define kDescription @"kDescription"
#define kRain @"kRain"
#define kTemperature @"kTemperature"

@interface ZBSessionInfo : NSObject
{
	NSString *_type;
	NSString *_name;
	NSURL *_URL;
	id _delegate;
}

+ (id)info;

@property (retain, nonatomic) NSString *type;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSURL *URL;
@property (assign) id delegate;

@end

@interface TWWeatherAPI : NSObject {
	LFHTTPRequest *_request;
}

+ (id)sharedAPI;

@end

@protocol ZBOverViewParserDelegate <NSObject>
- (void)overviewParserDidComplete:(TWWeatherAPI *)api text:(NSString *)text;
- (void)overviewParserDidFail:(TWWeatherAPI *)api;
@end

@protocol ZBForecastParserDelegate <NSObject>
- (void)foreCastParserDidComplete:(TWWeatherAPI *)api name:(NSString *)name forecasts:(NSArray *)forecasts;
- (void)foreCastParserDidFail:(TWWeatherAPI *)api;
@end

@protocol ZBGraphicDelegate <NSObject>
- (void)graphicDidComplete:(TWWeatherAPI *)api image:(UIImage *)image name:(NSString *)name;
- (void)graphicDidFail:(TWWeatherAPI *)api;
@end

@protocol ZBWeekDelegate <NSObject>
- (void)weekParsercDidComplete:(TWWeatherAPI *)api name:(NSString *)name week:(NSArray *)week;
- (void)weekParserDidFail:(TWWeatherAPI *)api;
@end

