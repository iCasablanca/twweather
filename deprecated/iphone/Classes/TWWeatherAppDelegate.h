//
//  TWWeatherAppDelegate.h
//  TWWeather
//
//  Created by zonble on 2009/1/12.
//  Copyright zonble.twbbs.org 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "TWWeatherAPI.h"

#define kLocationPreferenceName @"kLocationPreferenceName"

@interface TWWeatherAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;	
	NSDictionary *_rootDictionary;
	
	RootViewController *_rootViewController;
	NSString *_rootTitle;
}

- (void)updateRootForecast;

- (void)showLocationPicker;
- (void)hideLocationPicker;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSDictionary *rootDictionary;
@property (nonatomic, retain) RootViewController *rootViewController;
@property (nonatomic, retain) NSString *rootTitle;
@end

