//
//  ZBGraphicsListTableViewController.h
//  TWWeather
//
//  Created by zonble on 2009/1/12.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZBGraphicsListTableViewController : UITableViewController 
{
	NSMutableArray *_graphicsArray;
}

@property (readonly) NSArray *graphicsArray;

@end
