//
//  TWTwitterEngine.m
//  TWWeather
//
//  Created by zonble on 1/19/10.
//  Copyright 2010 Lithoglyph Inc.. All rights reserved.
//

#import "TWTwitterEngine.h"

static TWTwitterEngine *sharedInstance;

@implementation TWTwitterEngine

+ (TWTwitterEngine *)sharedInstance
{
	if (!sharedInstance) {
		sharedInstance = [[TWTwitterEngine alloc] initWithDelegate:nil];
	}
	return sharedInstance;
}

@end
