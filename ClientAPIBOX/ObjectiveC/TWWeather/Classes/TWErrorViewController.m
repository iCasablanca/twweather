//
//  TWErrorViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWErrorViewController.h"


@implementation TWErrorViewController

- (void)dealloc
{
	[_error release];
	[self viewDidUnload];
    [super dealloc];
}
- (void)viewDidUnload
{
	[super viewDidLoad];
	self.view = nil;
	[textLabel release];
}

#pragma mark UIViewContoller Methods

- (void)loadView 
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

	[view autorelease];
	self.view = view;
	self.title = NSLocalizedString(@"Error!", @"");
	
	textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 200)];
	textLabel.text = @"";
	textLabel.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:textLabel];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	NSString *description = [_error localizedDescription];
	if (description) {
		textLabel.text = description;
	}
	else {
		textLabel.text = @"Error!";
	}
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)setError:(NSError *)error
{
	id tmp = _error;
	_error = [error retain];
	[tmp release];
	NSString *description = [error localizedDescription];
	textLabel.text = description;
}

- (NSError *)error
{
	return _error;
}

@dynamic error;

@end
