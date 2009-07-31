//
//  TWBasicForecastTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import "TWBasicForecastTableViewController.h"
#import "TWLoadingCell.h"

@implementation TWBasicForecastTableViewController

- (void)dealloc 
{
	[_array release];
    [super dealloc];
}
- (void)viewDidUnload
{
	[super viewDidLoad];
}

- (void)_init
{
	_array = [[NSMutableArray alloc] init];
}

- (id)initWithStyle:(UITableViewStyle)style
{
	if (self = [super initWithStyle:style]) {
		[self _init];
	}
	return self;
}
- (id)initWithCoder:(NSCoder *)decoder
{
	if (self = [super initWithCoder:decoder]) {
		[self _init];
	}
	return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self _init];
	}
	return self;
}

#pragma mark UIViewContoller Methods

- (void)viewDidLoad 
{
	[super viewDidLoad];
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:NULL] autorelease];
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

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
- (void)setArray:(NSArray *)array
{
	[_array removeAllObjects];
	for (NSDictionary *d in array) {
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:d];
		[dictionary setObject:[NSNumber numberWithBool:NO] forKey:@"isLoading"];
		[_array addObject:dictionary];
	}
}
- (NSArray *)array
{
	return _array;
}

- (void)resetLoading
{
	for (NSMutableDictionary *d in _array) {
		[d setObject:[NSNumber numberWithBool:NO] forKey:@"isLoading"];
	}
	[self.tableView reloadData];
}

#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    TWLoadingCell *cell = (TWLoadingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TWLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	NSDictionary *dictionary = [_array objectAtIndex:indexPath.row];
	NSString *name = [dictionary objectForKey:@"name"];
    cell.textLabel.text = name;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	if ([[dictionary objectForKey:@"isLoading"] boolValue]) {
		[cell startAnimating];
	}
	else {
		[cell stopAnimating];
	}
	
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
}



@dynamic array;

@end

