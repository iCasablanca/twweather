//
//  TWThreeDaySeaResultTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWThreeDaySeaResultTableViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWThreeDaySeaCell.h"
#import "TWAPIBox.h"

@implementation TWThreeDaySeaResultTableViewController

- (void)dealloc 
{
	[forecastArray release];
	[publishTime release];
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
		
		NSString *feedTitle = [NSString stringWithFormat:@"%@ 三天漁業預報", [self title]];
		NSMutableString *description = [NSMutableString string];
		for (NSDictionary *forecast in forecastArray) {
			[description appendFormat:@"※ %@ ", [forecast valueForKey:@"date"]];
			[description appendFormat:@"%@ ", [forecast valueForKey:@"description"]];
			[description appendFormat:@"%@ ", [forecast valueForKey:@"wind"]];
			[description appendFormat:@"%@ ", [forecast valueForKey:@"windScale"]];
			[description appendFormat:@"%@ ", [forecast valueForKey:@"wave"]];
		}
		[description appendFormat:@" 發佈時間%@", publishTime];
		
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
    
    TWThreeDaySeaCell *cell = (TWThreeDaySeaCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TWThreeDaySeaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	NSDictionary *dictionary = [forecastArray objectAtIndex:indexPath.row];
	NSString *dateString = [dictionary objectForKey:@"date"];
	NSDate *date = [[TWAPIBox sharedBox] dateFromShortString:dateString];
	cell.date = [[TWAPIBox sharedBox] shortDateStringFromDate:date];	
	cell.description = [dictionary objectForKey:@"description"];
	cell.wind = [dictionary objectForKey:@"wind"];
	cell.windScale = [dictionary objectForKey:@"windScale"];
	cell.wave = [dictionary objectForKey:@"wave"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSString *imageString = [[TWWeatherAppDelegate sharedDelegate] imageNameWithTimeTitle:@"" description:cell.description ];
	cell.weatherImage = [UIImage imageNamed:imageString];

	[cell setNeedsDisplay];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 120.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString *time = [NSString stringWithFormat:@"發布時間：%@", publishTime];
	return time;
}

@synthesize forecastArray;
@synthesize publishTime;

@end

