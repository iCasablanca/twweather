//
//  TWWeatherAppDelegate+BGM.m
//  TWWeather
//
//  Created by zonble on 10/13/09.
//

#import "TWWeatherAppDelegate+BGM.h"

@implementation TWWeatherAppDelegate(BGM)

- (void)startPlayingBGM
{
	if (audioPlayer) {
		[audioPlayer stop];
		[audioPlayer release];
	}
	NSString *path = [[NSBundle mainBundle] pathForResource:@"bgm" ofType:@"mp3"];
	NSURL *URL = [NSURL fileURLWithPath:path];
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:&error];
	if (error) {
		NSLog(@"error:%@", [error description]);
		return;
	}
	audioPlayer.delegate = self;
	[audioPlayer play];
}
- (void)stopPlayingBGM
{
	if (audioPlayer) {
		[audioPlayer stop];
		[audioPlayer release];
		audioPlayer = nil;
	}	
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
	[player play];
}

@end
