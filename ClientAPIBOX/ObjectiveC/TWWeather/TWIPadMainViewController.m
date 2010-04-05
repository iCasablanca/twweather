//
//  TWIPadMainViewController.m
//  TWWeather
//
//  Created by zonble on 4/6/10.
//  Copyright 2010 Lithoglyph Inc. All rights reserved.
//

#import "TWIPadMainViewController.h"


@implementation TWIPadMainViewController

- (void)removeOutletsAndControls_TWIPadMainViewController
{
	// remove and clean outlets and controls here
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	[self removeOutletsAndControls_TWIPadMainViewController];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
	[self removeOutletsAndControls_TWIPadMainViewController];
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}



/*
// The designated initializer.  Override if you create the controller
// programmatically and want to perform customization that is not appropriate 
// for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Custom initialization
	}
	return self;
}
*/

#pragma mark -
#pragma mark UIViewContoller Methods

/*
// Implement loadView to create a view hierarchy programmatically, without
// using a nib.
- (void)loadView 
{
}
*/
/*
- (void)viewDidLoad 
{
	[super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated 
{
	[super viewDidDisappear:animated];
}
*/


#pragma mark -
#pragma mark Instance methods


#pragma mark -
#pragma mark Interface Builder actions

#pragma mark -
#pragma mark Properties

@end
