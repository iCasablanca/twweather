//
//  TWTideResultTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWTideResultTableViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWTideCell.h"
#import "TWAPIBox.h"

@implementation TWTideResultTableViewController

- (void)dealloc 
{
	[forecastArray release];
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
		
		NSString *feedTitle = [NSString stringWithFormat:@"%@ 三天潮汐", [self title]];
		NSMutableString *description = [NSMutableString string];
		for (NSDictionary *forecast in forecastArray) {
			[description appendFormat:@"※ %@ ", [forecast objectForKey:@"date"]];
			[description appendFormat:@"%@ ", [forecast objectForKey:@"lunarDate"]];
			for (NSDictionary *tide in [forecast objectForKey:@"tides"]) {
				NSString *name = [tide objectForKey:@"name"];
				NSString *shortTime = [tide objectForKey:@"shortTime"];
				NSString *height = [tide objectForKey:@"height"];
				[description appendFormat:@"%@ %@ %@ -", name, shortTime, height];
			}
		}
		
		NSString *attachment = [NSString stringWithFormat:@"{\"name\":\"%@\", \"description\":\"%@\"}", feedTitle, description];
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
    return [forecastArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    TWTideCell *cell = (TWTideCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TWTideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	NSDictionary *dictionary = [forecastArray objectAtIndex:indexPath.row];
	
	NSString *dateString = [dictionary objectForKey:@"date"];
	NSDate *date = [[TWAPIBox sharedBox] dateFromShortString:dateString];
	cell.dateString = [[TWAPIBox sharedBox] shortDateStringFromDate:date];
	cell.lunarDateString = [dictionary objectForKey:@"lunarDate"];
	cell.tides = [dictionary objectForKey:@"tides"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell setNeedsDisplay];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *dictionary = [forecastArray objectAtIndex:indexPath.row];
	NSArray *tides = [dictionary objectForKey:@"tides"];
	return 60.0 + [tides count] * 30.0;
}


@synthesize forecastArray;

@end

