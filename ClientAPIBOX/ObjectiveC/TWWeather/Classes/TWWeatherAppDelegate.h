//
//  TWWeatherAppDelegate.h
//  TWWeather
//
//  Created by zonble on 2009/07/31.s
//

#import <AVFoundation/AVFoundation.h>
#import "FBconnect/FBConnect.h"
#import "TWFacebookAPI.h"

@interface TWWeatherAppDelegate : NSObject <UIApplicationDelegate, AVAudioPlayerDelegate,FBSessionDelegate, FBDialogDelegate> 
{
    UIWindow *window;
	UINavigationController *navigationController;
    UITabBarController *tabBarController;
	
	AVAudioPlayer *audioPlayer;
	FBSession *facebookSession;
}

+ (TWWeatherAppDelegate*)sharedDelegate;

- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated;
- (NSString *)imageNameWithTimeTitle:(NSString *)timeTitle description:(NSString *)description;

#pragma mark Facebook

- (BOOL)confirmFacebookLoggedIn;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, readonly) FBSession *facebookSession;;

@end

