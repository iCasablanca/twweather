//
//  TWLocationSettingTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "TWLocationSettingTableViewController.h"
#import "TWWeatherAppDelegate.h"
#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"

@implementation TWLocationSettingTableViewController

- (void)dealloc 
{
	[_filterArray release];
    [super dealloc];
}

#pragma mark UIViewContoller Methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.title = @"My Favorites";
	
	if (!_filterArray) {
		_filterArray = [[NSMutableArray alloc] init];
	}
	
	UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donelAction:)];
	self.navigationItem.rightBarButtonItem = cancelItem;
	[cancelItem release];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
- (void)setFilter:(NSArray *)filter
{
	if (!_filterArray) {
		_filterArray = [[NSMutableArray alloc] init];
	}	
	[_filterArray setArray:filter];
}
- (IBAction)donelAction:(id)sender
{
	if (delegate && [delegate respondsToSelector:@selector(settingController:didUpdateFilter:)]) {
		[delegate settingController:self didUpdateFilter:_filterArray];		
	}
	if ([self.navigationController parentViewController]) {
		[[self.navigationController parentViewController] dismissModalViewControllerAnimated:YES];
	}
}

#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[TWAPIBox sharedBox] forecastLocations] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary *dictionary = [[[TWAPIBox sharedBox] forecastLocations] objectAtIndex:indexPath.row];
	NSString *name = [dictionary objectForKey:@"name"];
	cell.textLabel.text = name;
	NSNumber *number = [NSNumber numberWithInt:indexPath.row];
	if ([_filterArray containsObject:number]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSNumber *number = [NSNumber numberWithInt:indexPath.row];
	if ([_filterArray containsObject:number]) {
		if ([_filterArray count] == 1 && [_filterArray objectAtIndex:0] == number) {
			return;
		}
		[_filterArray removeObject:number];
	}
	else {
		[_filterArray addObject:number];
	}
	[self.tableView reloadData];
}

@synthesize delegate;

@end

