//
//  TWNearSeaResultViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWNearSeaResultTableViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWNearSeaCell.h"

@implementation TWNearSeaResultTableViewController

- (void)dealloc 
{
	[publishTime release];
	[description release];
	[validBeginTime release];
	[validEndTime release];
	[wave release];
	[waveLevel release];
	[wind release];
	[windScale release];
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
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(navBarAction:)];
	self.navigationItem.rightBarButtonItem = item;
	[item release];	
}

#pragma mark -

- (IBAction)navBarAction:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Share via Facebook", @""), nil];
	[actionSheet showInView:[self view]];
	[actionSheet release];
}
- (void)shareViaFacebook
{
	if ([[TWWeatherAppDelegate sharedDelegate] confirmFacebookLoggedIn]) {
		FBStreamDialog *dialog = [[[FBStreamDialog alloc] init] autorelease];
		dialog.delegate = [TWWeatherAppDelegate sharedDelegate];
		
		NSString *feedTitle = [NSString stringWithFormat:@"%@ 天氣預報", [self title]];
		NSMutableString *attachmentDescription = [NSMutableString string];
		[attachmentDescription appendFormat:@"※ %@ - %@ ", self.validBeginTime, self.validEndTime];
		[attachmentDescription appendFormat:@"%@ ", self.description];
		[attachmentDescription appendFormat:@"%@ ", self.wave];
		[attachmentDescription appendFormat:@"%@ ", self.waveLevel];
		[attachmentDescription appendFormat:@"%@ ", self.wind];
		[attachmentDescription appendFormat:@"%@ ", self.windScale];
				
		NSString *attachment = [NSString stringWithFormat:@"{\"name\":\"%@\", \"description\":\"%@\"}", feedTitle, attachmentDescription];
		dialog.attachment = attachment;
		dialog.userMessagePrompt = feedTitle;
		[dialog show];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (!buttonIndex) {
		[self shareViaFacebook];
	}
}

#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    TWNearSeaCell *cell = (TWNearSeaCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TWNearSeaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.description = self.description;
	cell.validBeginTime = self.validBeginTime;
	cell.validEndTime = self.validEndTime;
	cell.wave = self.wave;
	cell.waveLevel = self.waveLevel;
	cell.wind = self.wind;
	cell.windScale = self.windScale;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSString *imageString = [[TWWeatherAppDelegate sharedDelegate] imageNameWithTimeTitle:@"" description:cell.description ];
	cell.imageView.image = [UIImage imageNamed:imageString];
	
	[cell setNeedsDisplay];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 320.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *time = [NSString stringWithFormat:@"發布時間：%@", publishTime];
	return time;
}

@synthesize description;
@synthesize publishTime;
@synthesize validBeginTime;
@synthesize validEndTime;
@synthesize wave;
@synthesize waveLevel;
@synthesize wind;
@synthesize windScale;

@end
