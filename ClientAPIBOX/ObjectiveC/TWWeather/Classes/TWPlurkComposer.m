//
//  TWPlurkComposer.m
//  TWWeather
//
//  Created by zonble on 12/26/09.
//

#import "TWPlurkComposer.h"
#import "TWPlurkBackgroudView.h"

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
	[composer updateWordCount];
}

@end


@implementation TWPlurkComposerViewController

- (void)removeOutletsAndControls_TWPlurkComposer
{
	[textView release];
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
}


#pragma mark -
#pragma mark UIViewContoller Methods

- (void)loadView 
{
	TWPlurkBackgroudView *aView = [[[TWPlurkBackgroudView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
	aView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	aView.backgroundColor = [UIColor whiteColor];
	self.view = aView;
	
	textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 170)];
	textView.backgroundColor = [UIColor clearColor];
	textView.editable = YES;
	textView.contentOffset = CGPointMake(10, 10);
	textView.font = [UIFont systemFontOfSize:14.0];
	textView.keyboardAppearance = UIKeyboardAppearanceAlert;
	textView.delegate = self;
	[self.view addSubview:textView];
	
	wordCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 190, 300, 10)];
	wordCountLabel.textColor = [UIColor whiteColor];
	wordCountLabel.font = [UIFont systemFontOfSize:10.0];
	wordCountLabel.textAlignment = UITextAlignmentCenter;
	wordCountLabel.backgroundColor = [UIColor blackColor];
	[self.view addSubview:wordCountLabel];
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
    [super didReceiveMemoryWarning];
}

- (void)updateWordCount
{
	NSUInteger count = [textView.text length];
	NSString *s = [NSString stringWithFormat:@"%d/140", count];
	wordCountLabel.text = s;
}

- (IBAction)cancelAction:(id)sender
{
	if (self.navigationController.parentViewController) {
		[self.navigationController.parentViewController dismissModalViewControllerAnimated:YES];
		textView.editable = YES;
	}
}
- (IBAction)doneAction:(id)sender
{
	NSString *content = textView.text;
	textView.editable = NO;
	[[ObjectivePlurk sharedInstance] addNewMessageWithContent:content qualifier:@"shares" othersCanComment:YES lang:@"tr_ch" limitToUsers:nil delegate:self userInfo:nil];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	[self updateWordCount];
}

- (void)plurk:(ObjectivePlurk *)plurk didAddMessage:(NSDictionary *)result
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self cancelAction:self];
}
- (void)plurk:(ObjectivePlurk *)plurk didFailAddingMessage:(NSError *)error
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	textView.editable = YES;
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to post on Plurk", @"") message:[error localizedDescription] delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

@synthesize textView;

@end
