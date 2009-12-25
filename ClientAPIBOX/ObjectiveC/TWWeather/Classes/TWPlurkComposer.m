//
//  TWPlurkComposer.m
//  TWWeather
//
//  Created by zonble on 12/26/09.
//

#import "TWPlurkComposer.h"

static TWPlurkComposer *sharedComposer;

@implementation TWPlurkComposer

+ (TWPlurkComposer *)sharedComposer
{
	if (!sharedComposer) {
		TWPlurkComposerViewController *viewController = [[TWPlurkComposerViewController alloc] init];
		sharedComposer = [[TWPlurkComposer alloc] initWithRootViewController:viewController];
		sharedComposer.navigationBar.barStyle = UIBarStyleBlack;
		[viewController release];
	}
	return sharedComposer;
}

- (void)showWithController:(UIViewController *)controller text:(NSString *)text
{
	if (![[ObjectivePlurk sharedInstance] isLoggedIn]) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please login Plurk.", @"") message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}

	TWPlurkComposerViewController *composer = (TWPlurkComposerViewController *)[[self viewControllers] objectAtIndex:0];
	[composer view];
	[controller presentModalViewController:self animated:YES];

	composer.textView.text = text;
}

@end


@implementation TWPlurkComposerViewController

- (void)removeOutletsAndControls_TWPlurkComposer
{
	[textView release];
    // remove and clean outlets and controls here
}

- (void)dealloc 
{
	[self removeOutletsAndControls_TWPlurkComposer];
    [super dealloc];
}
- (void)viewDidUnload
{
	[super viewDidUnload];
	[self removeOutletsAndControls_TWPlurkComposer];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark UIViewContoller Methods

- (void)loadView 
{
	UIView *aView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
	aView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	aView.backgroundColor = [UIColor whiteColor];
	self.view = aView;
	
	textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
//	textView.backgroundColor = [UIColor redColor];
	textView.editable = YES;
	textView.contentOffset = CGPointMake(10, 10);
	textView.font = [UIFont systemFontOfSize:14.0];
//	textView.keyboardAppearance = UIKeyboardAppearanceAlert;
	[self.view addSubview:textView];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
	self.navigationItem.leftBarButtonItem = cancelItem;
	[cancelItem release];

	UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
	self.navigationItem.rightBarButtonItem = doneItem;
	[doneItem release];
	
}
- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	[textView becomeFirstResponder];
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
}
- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewDidDisappear:(BOOL)animated 
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

	// Release any cached data, images, etc that aren't in use.
}

- (IBAction)cancelAction:(id)sender
{
	if (self.navigationController.parentViewController) {
		[self.navigationController.parentViewController dismissModalViewControllerAnimated:YES];
	}
}
- (IBAction)doneAction:(id)sender
{
	NSString *content = textView.text;
	[[ObjectivePlurk sharedInstance] addNewMessageWithContent:content qualifier:@"shares" othersCanComment:YES lang:@"tr_ch" limitToUsers:nil delegate:self userInfo:nil];
}

- (void)plurk:(ObjectivePlurk *)plurk didAddMessage:(NSDictionary *)result
{
	[self cancelAction:self];
}
- (void)plurk:(ObjectivePlurk *)plurk didFailAddingMessage:(NSError *)error
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to post on Plurk", @"") message:[error localizedDescription] delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

@synthesize textView;

@end
