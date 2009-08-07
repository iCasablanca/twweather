//
//  TWWeatherAppDelegate.h
//  TWWeather
//
//  Created by zonble on 2009/07/31.s
//

extern NSString *TWCurrentForecastDidFetchNotification;
extern NSString *forecastOfCurrentLocationPreference;
extern NSString *currentLocationPreference;

@interface TWWeatherAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
	UINavigationController *navigationController;
    UITabBarController *tabBarController;
}

+ (TWWeatherAppDelegate*)sharedDelegate;

- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated;
- (NSString *)imageNameWithTimeTitle:(NSString *)timeTitle description:(NSString *)description;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

