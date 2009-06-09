//
//  ZBGraphicsListTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/1/12.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "ZBGraphicsListTableViewController.h"
#import "ZBGraphicsListTableViewCell.h"
#import "ZBGraphicViewController.h"
#import "ZBFileCache.h"

@implementation ZBGraphicsListTableViewController

- (void)dealloc
{
	[_graphicsArray release];
	[super dealloc];
}
- (void)addGraphicsWithName:(NSString *)name URLString:(NSString *)URLString
{
	NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", URLString, @"URLString", nil];
	[_graphicsArray addObject:d];
}
- (void)_init
{
	_graphicsArray = [NSMutableArray new];	
	[self addGraphicsWithName:[NSString stringWithUTF8String:"彩色衛星雲圖（台灣）"]
                    URLString:@"http://www.cwb.gov.tw/V6/observe/satellite/Data/s3p/s3p150.jpg"];	
	[self addGraphicsWithName:[NSString stringWithUTF8String:"彩色衛星雲圖（東亞）"]
                    URLString:@"http://www.cwb.gov.tw/V6/observe/satellite/Data/s1p/s1p.jpg"];
	[self addGraphicsWithName:[NSString stringWithUTF8String:"色調強化衛星雲圖（台灣）"]
                    URLString:@"http://www.cwb.gov.tw/V6/observe/satellite/Data/s3q/s3q.jpg"];
	[self addGraphicsWithName:[NSString stringWithUTF8String:"色調強化衛星雲圖（東亞）"]
                    URLString:@"http://www.cwb.gov.tw/V6/observe/satellite/Data/s1q/s1q.jpg"];
	[self addGraphicsWithName:[NSString stringWithUTF8String:"雨量累積圖"]
                    URLString:@"http://www.cwb.gov.tw/V6/observe/rainfall/Data/hk.jpg"];
	[self addGraphicsWithName:[NSString stringWithUTF8String:"雷達回波圖"]
                    URLString:@"http://www.cwb.gov.tw/mobile/radar/Data/r5o/Lms150.gif"];	
}
- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self != nil) {
		[self _init];
	}
	return self;
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.tableView setScrollEnabled:NO];
	[self.tableView reloadData];
}
- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.title = [NSString stringWithUTF8String:"天氣雲圖"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [_graphicsArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";

    ZBGraphicsListTableViewCell *cell = (ZBGraphicsListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ZBGraphicsListTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSDictionary *d = [_graphicsArray objectAtIndex:indexPath.row];
	NSString *name = [d valueForKey:@"name"];
	cell.graphicTitle = name;
	cell.graphicImage = nil;
	NSString *URLString = [d valueForKey:@"URLString"];
	NSString *path = [ZBFileCache cachePathForURL:[NSURL URLWithString:URLString]];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		UIImage *image = [UIImage imageWithContentsOfFile:path];
		cell.graphicImage = image;
	}
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSDictionary *d = [_graphicsArray objectAtIndex:indexPath.row];
	NSString *name = [d valueForKey:@"name"];
	NSString *URLString = [d valueForKey:@"URLString"];
	ZBGraphicViewController *controller = [[ZBGraphicViewController alloc] initWithNibName:@"ZBGraphicViewController" bundle:[NSBundle mainBundle]];
	controller.delegate = self;
	[self.navigationController pushViewController:controller animated:YES];	
	[controller loadGraphicWithName:name URLString:URLString index:indexPath.row];
	[controller release];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 63.0;
}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}

@synthesize graphicsArray = _graphicsArray;

@end

