//
//  ZBOverviewViewController.m
//  TWWeather
//
//  Created by zonble on 2009/1/13.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "ZBOverviewViewController.h"
#import "TWWeatherAPI.h"
#import "TWWeatherAPI+OverViewParser.h"

@implementation ZBOverviewViewController

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
}
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = [NSString stringWithUTF8String:"關心天氣"];
}
- (void)parse
{
	[[TWWeatherAPI sharedAPI] fetchOverviewWithDelegate:self];
}

- (void)overviewParserDidComplete:(TWWeatherAPI *)api text:(NSString *)text
{
	[(UITextView *)self.view setText:text];
}
- (void)overviewParserDidFail:(TWWeatherAPI *)api
{
	[(UITextView *)self.view setText:[NSString stringWithUTF8String:"無法載入天氣概況"]];
}

@end
