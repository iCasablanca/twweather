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
	[textLabel release];
	textLabel = nil;
	self.view = nil;
}

#pragma mark UIViewContoller Methods

- (void)loadView 
{
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
	view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	view.backgroundColor = [UIColor colorWithHue:1.0 saturation:0.0 brightness:0.9 alpha:1.0];
	self.view = view;
	self.title = NSLocalizedString(@"Error!", @"");
	
	textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 200)];
	textLabel.text = @"";
	textLabel.textAlignment = UITextAlignmentCenter;
	textLabel.numberOfLines = 10;
	textLabel.font = [UIFont boldSystemFontOfSize:18.0];
	textLabel.backgroundColor = [UIColor colorWithHue:1.0 saturation:0.0 brightness:0.9 alpha:1.0];
	textLabel.shadowColor = [UIColor whiteColor];
	textLabel.shadowOffset = CGSizeMake(0, 2);
	
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
