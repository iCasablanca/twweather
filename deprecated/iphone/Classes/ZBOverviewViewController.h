//
//  ZBOverviewViewController.h
//  TWWeather
//
//  Created by zonble on 2009/1/13.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWWeatherAPI.h"

@interface ZBOverviewViewController : UIViewController <ZBOverViewParserDelegate>{
}

- (void)parse;

@end
