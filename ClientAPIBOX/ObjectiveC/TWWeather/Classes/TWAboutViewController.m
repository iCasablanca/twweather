//
//  TWAboutViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/02.
//

#import "TWAboutViewController.h"


@implementation TWAboutViewController

- (void)dealloc
{
	[self viewDidUnload];
    [super dealloc];
}

- (void)viewDidUnload
{
	self.titleLabel = nil;
	self.copyrightLabel = nil;
	self.externalLibraryLabel = nil;
	self.view = nil;
}

#pragma mark UIViewContoller Methods

- (void)loadView 
{
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
	view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	self.view = view;
	self.title = NSLocalizedString(@"About", @"");
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Feedback",@"") style:UIBarButtonItemStyleBordered target:self action:@selector(sendEmailAction:)];
	self.navigationItem.rightBarButtonItem = item;
	[item release];
	
	NSBundle *bundle = [NSBundle mainBundle];
	NSDictionary *loaclizedDictionary = [bundle localizedInfoDictionary];
	NSDictionary *infoDictionary = [bundle infoDictionary];
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 30)] autorelease];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.text = [loaclizedDictionary objectForKey:@"CFBundleDisplayName"];
	self.titleLabel = label;
	[self.view addSubview:self.titleLabel];
	
	label = [[[UILabel alloc] initWithFrame:CGRectMake(20, 50, 280, 60)] autorelease];
	label.font = [UIFont systemFontOfSize:14.0];
	label.numberOfLines = 3;	
	label.text = [NSString stringWithFormat:NSLocalizedString(@"Version: %@\n%@", @""), [infoDictionary objectForKey:@"CFBundleVersion"], [loaclizedDictionary objectForKey:@"NSHumanReadableCopyright"]];
	self.copyrightLabel = label;
	[self.view addSubview:self.copyrightLabel];
	
	label = [[[UILabel alloc] initWithFrame:CGRectMake(20, 120, 280, 280)] autorelease];
	label.font = [UIFont systemFontOfSize:12.0];
	label.numberOfLines = 100;
	label.text = [NSString stringWithFormat:NSLocalizedString(@"%@ is an open source project. please check the web site of the project(http://github.com/zonble/twweather) for furthor information.\n\nLFWebAPIKit\nCopyright (c) 2007-2009 Lithoglyph Inc. (http://lithoglyph.com)\nCopyright (c) 2007-2009 Lukhnos D. Liu (http://lukhnos.org)\n\nCocoaCryptoHashing\nCopyright (c) 2004-2009 Denis Defreyne\nCopyright (c) 2008 Chris Verwymeren\nCopyright (c) 2009 Mike Fischer\nAll rights reserved.", @""), [loaclizedDictionary objectForKey:@"CFBundleDisplayName"]];
	self.externalLibraryLabel = label;
	[self.view addSubview:self.externalLibraryLabel];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)sendEmailAction:(id)sender
{
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
		controller.mailComposeDelegate = self;
		[controller setSubject:NSLocalizedString(@"TW Weather Questions/Inquery", @"")];
		[controller setToRecipients:[NSArray arrayWithObject:@"Weizhong Yang<zonble+twweather@gmail.com>"]];
		[self presentModalViewController:controller animated:YES];
		[controller release];
	}
	else {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You cannot send email now",@"") message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
}

#pragma mark -

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	UIViewController *parentController = controller.parentViewController;
	[parentController dismissModalViewControllerAnimated:YES];
	if (result == MFMailComposeResultSent) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Your mail is sent!", @"") message:NSLocalizedString(@"Thanks for your feedback.", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
}

@synthesize titleLabel;
@synthesize copyrightLabel;
@synthesize externalLibraryLabel;

@end
