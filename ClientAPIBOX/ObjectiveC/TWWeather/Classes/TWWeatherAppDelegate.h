//
//  TWWeatherAppDelegate.h
//  TWWeather
//
//  Created by zonble on 2009/07/31.s
//

@interface TWWeatherAppDelegate : NSObject <UIApplicationDelegate> 
{
    
    UIWindow *window;
    UINavigationController *navigationController;
}

+ (TWWeatherAppDelegate*)sharedDelegate;
- (NSString *)imageNameWithTimeTitle:(NSString *)timeTitle description:(NSString *)description;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

