//
//  TWWeatherAppDelegate.h
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//  Copyright Lithoglyph Inc. 2009. All rights reserved.
//

@interface TWWeatherAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

