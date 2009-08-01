//
//  TWImageViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//  Copyright 2009 Lithoglyph Inc.. All rights reserved.
//

#import "TWImageViewController.h"


@implementation TWImageViewController

- (void)dealloc
{
	[_image release];
	[self viewDidUnload];
    [super dealloc];
}
- (void)viewDidUnload
{
	self.imageView = nil;
	self.view = nil;
}
- (void)loadView 
{
	UIScrollView *view = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)] autorelease];
	view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;	
	view.backgroundColor = [UIColor blackColor];
	view.canCancelContentTouches = NO;
	view.clipsToBounds = YES; 
	view.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	view.minimumZoomScale = 1;
	view.maximumZoomScale = 2.5;
	view.scrollEnabled = YES;
	view.delegate = self;
	view.userInteractionEnabled = YES;
	self.view = view;
	
	UIImageView *imageView = [[[UIImageView alloc] initWithFrame:self.view.bounds] autorelease];
	imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	imageView.backgroundColor = [UIColor blackColor];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.imageView = imageView;
	[view setContentSize:self.imageView.frame.size];
	[view addSubview:imageView];
}


#pragma mark UIViewContoller Methods

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
}
*/
- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.imageView.image = self.image;
	[(UIScrollView *)self.view setContentSize:_imageView.frame.size];
}
- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
//	self.navigationController.navigationBar.translucent = YES;
}
- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//	self.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidDisappear:(BOOL)animated 
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
//{
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.5];
//	
//	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
//		CGAffineTransform transform = CGAffineTransformMakeRotation(-90.0 * 3.14/180);
//		self.imageView.transform = transform;
//		self.imageView.frame = CGRectMake(0, 0, [self.view bounds].size.width, [self.view bounds].size.height);		
//	}
//	else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//		CGAffineTransform transform = CGAffineTransformMakeRotation(90.0 * 3.14/180);			
//		self.imageView.transform = transform;
//		self.imageView.frame = CGRectMake(0, 0, [self.view bounds].size.width, [self.view bounds].size.height);			
//	}	
//	else {
//		CGAffineTransform transform = CGAffineTransformMakeRotation(0.0 * 3.14/180);	
//		self.imageView.transform = transform;
//		self.imageView.frame = CGRectMake(0, 0, [self.view bounds].size.width, [self.view bounds].size.height);				
//	}
//	
//	[(UIScrollView *)self.view setContentSize:_imageView.frame.size];
//	[UIView commitAnimations];
//	return NO;
//}

- (void)setImage:(UIImage *)image
{
	id tmp = _image;
	_image = [image retain];
	[tmp release];
	self.imageView.image = image;
}
- (UIImage *)image
{
	return _image;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return _imageView;
}

@synthesize imageView = _imageView;
@dynamic image;

@end
