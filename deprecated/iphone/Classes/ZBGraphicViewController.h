//
//  ZBGraphicViewController.h
//  TWWeather
//
//  Created by zonble on 2009/1/12.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFHTTPRequest.h"

@interface ZBGraphicViewController : UIViewController <UIScrollViewDelegate> {
	id _delegate;
	
//	LFHTTPRequest *_request;
	IBOutlet UIImageView *_imageView;
	IBOutlet UISegmentedControl *_segmentedControl;
	UIBarButtonItem *_pageBarItem;
	
	NSString *_name;
	NSString *_URLString;
	NSInteger _index;
}

- (void)loadGraphic;
- (void)loadGraphicWithName: (NSString *)name URLString:(NSString *)URLString index:(NSInteger)index;

- (IBAction)gotoAnotherGraphicAction:(id)sender;

@property (assign) id delegate;
@property (readwrite, retain) NSString *name;
@property (readwrite, retain) NSString *URLString;
@property (assign) NSInteger index;

@end
