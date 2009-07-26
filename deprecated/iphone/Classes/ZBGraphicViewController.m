//
//  ZBGraphicViewController.m
//  TWWeather
//
//  Created by zonble on 2009/1/12.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import "ZBGraphicViewController.h"
#import "ZBGraphicsListTableViewController.h"
#import "ZBFileCache.h"
#import "TWWeatherAPI.h"
#import "TWWeatherAPI+Graphic.h"

@implementation ZBGraphicViewController

- (void)dealloc 
{
	[_imageView release];
	[_segmentedControl release];
	[_pageBarItem release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)viewDidLoad 
{
	_imageView.contentMode = (UIViewContentModeScaleAspectFit);
	_imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	_imageView.backgroundColor = [UIColor whiteColor];
	UIScrollView *scrollView = (UIScrollView *)self.view;
	self.view.backgroundColor = [UIColor blackColor];
	scrollView.canCancelContentTouches = NO;
	scrollView.clipsToBounds = YES; 
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.minimumZoomScale = 1;
	scrollView.maximumZoomScale = 2.5;
	scrollView.delegate = self;
	[scrollView setScrollEnabled:YES];
	
	_pageBarItem = [[UIBarButtonItem alloc] initWithCustomView:_segmentedControl];	
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	self.navigationItem.rightBarButtonItem = _pageBarItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
		CGAffineTransform transform = CGAffineTransformMakeRotation(-90 * 3.14/180);
		_imageView.transform = transform;
		_imageView.frame = CGRectMake(0, 0, [self.view bounds].size.width, [self.view bounds].size.height);		
	}
	else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		CGAffineTransform transform = CGAffineTransformMakeRotation(90 * 3.14/180);			
		_imageView.transform = transform;
		_imageView.frame = CGRectMake(0, 0, [self.view bounds].size.width, [self.view bounds].size.height);			
	}	
	else {
		CGAffineTransform transform = CGAffineTransformMakeRotation(0);			
		_imageView.transform = transform;
		_imageView.frame = CGRectMake(0, 0, [self.view bounds].size.width, [self.view bounds].size.height);				
	}

	[(UIScrollView *)self.view setContentSize:_imageView.frame.size];
	[UIView commitAnimations];
    // Return YES for supported orientations
	return NO;
}
- (void)setName:(NSString *)name
{
	id tmp = _name;
	_name = [name retain];
	[tmp release];
	self.title = name;
}
- (void)loadGraphic
{
	[[TWWeatherAPI sharedAPI] fetchGraphicWithDelegate:self name:_name URLString:_URLString];
}
- (void)loadGraphicWithName: (NSString *)name URLString:(NSString *)URLString index:(NSInteger)index
{
	self.name = name;
	self.URLString = URLString;
	self.index = index;	
	[self loadGraphic];
}
- (IBAction)gotoAnotherGraphicAction:(id)sender
{
	UISegmentedControl *control = (UISegmentedControl *)sender;
	NSInteger index = [control selectedSegmentIndex];
	NSInteger newIndex = _index;
	if ([_delegate respondsToSelector:@selector(graphicsArray)]) {
		NSArray *a = [_delegate graphicsArray];
		switch (index) {
			case 0:
				if (_index > 0)
					newIndex = _index - 1;
				break;
			case 1:
				if (_index < [a count] -1)
					newIndex = _index + 1;
				break;
			default:
				break;
		}
		if (_index != newIndex) {
			NSDictionary *d = [a objectAtIndex:newIndex];
			NSString *name = [d valueForKey:@"name"];
			NSString *URLString = [d valueForKey:@"URLString"];
			[self loadGraphicWithName:name URLString:URLString index:newIndex];
		}
	}
}

#pragma mark -

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView 
{	
	return _imageView;
}
- (void)graphicDidComplete:(TWWeatherAPI *)api image:(UIImage *)image name:(NSString *)name
{
	_imageView.image = image;
	[_imageView setFrame:[self.view bounds]];
}
- (void)graphicDidFail:(TWWeatherAPI *)api
{
	UIAlertView *a = [[UIAlertView alloc] initWithTitle:[NSString stringWithUTF8String:"無法載入氣象雲圖"] message:[NSString stringWithUTF8String:"請檢查您的網路狀態是否正常"] delegate:self cancelButtonTitle:[NSString stringWithUTF8String:"關閉"] otherButtonTitles:nil];
	[a show];
	[a release];
}

@synthesize delegate = _delegate;
@synthesize name = _name;
@synthesize URLString = _URLString;
@synthesize index = _index;

@end
