//
//  TWBasicForecastTableViewController.m
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import "TWBasicForecastTableViewController.h"
#import "TWAPIBox.h"
#import "TWLoadingCell.h"
#import "TWErrorViewController.h"

@implementation TWBasicForecastTableViewController

- (void)dealloc 
{
	[self viewDidUnload];
	[_array release];
	[_filteredArray release];
    [super dealloc];
}
- (void)viewDidUnload
{
	[_searchBar release];
	_searchBar = nil;
	[_searchController release];
	_searchController = nil;
	self.tableView = nil;
	self.view = nil;
	[super viewDidLoad];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[TWAPIBox sharedBox] cancelAllRequestWithDelegate:self];
}

- (void)_init
{
	if (!_array) {
		_array = [[NSMutableArray alloc] init];
	}
	if (!_filteredArray) {
		_filteredArray = [[NSMutableArray alloc] init];
	}
	
}

- (id)initWithStyle:(UITableViewStyle)style
{
	if (self = [super initWithStyle:style]) {
		self.style = style;
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

- (void)loadView 
{
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view = view;
	
	UITableView *aTableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:self.style] autorelease];
	aTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	aTableView.delegate = self;
	aTableView.dataSource = self;
	self.tableView = aTableView;
	[self.view addSubview:self.tableView];
	
	if (!_searchBar) {
		_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
		_searchBar.delegate = self;
		_searchBar.tintColor = [UIColor grayColor];
	}
	if (!_searchController) {
		_searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
		_searchController.delegate = self;
		_searchController.searchResultsDataSource = self;
		_searchController.searchResultsDelegate = self;	
	}
}


#pragma mark UIViewContoller Methods

- (void)viewDidLoad 
{
	[super viewDidLoad];
	self.tableView.tableHeaderView = _searchBar;
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleBordered target:nil action:NULL] autorelease];
	_firstTimeVisiable = YES;	
}
- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
	if (_firstTimeVisiable) {
		[self.tableView scrollRectToVisible:CGRectMake(0, 40, 320, 420) animated:NO];
		_firstTimeVisiable = NO;
	}
	self.searchDisplayController.active = NO;
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
- (NSArray *)arrayForTableView:(UITableView *)tableView
{
	if (tableView == _searchController.searchResultsTableView) {
		return _filteredArray;
	}
	return _array;
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
	[_searchController.searchResultsTableView reloadData];
	self.tableView.userInteractionEnabled = YES;
	_searchController.searchResultsTableView.userInteractionEnabled = YES;
}
- (void)pushErrorViewWithError:(NSError *)error
{
	TWErrorViewController *controller = [[TWErrorViewController alloc] init];
	controller.error = error;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *array = [self arrayForTableView:tableView];
    return [array count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    TWLoadingCell *cell = (TWLoadingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TWLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	NSArray *array = [self arrayForTableView:tableView];
	NSDictionary *dictionary = [array objectAtIndex:indexPath.row];
	NSString *name = [dictionary objectForKey:@"name"];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[_filteredArray removeAllObjects];
	searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	for (NSDictionary *d in _array) {
		NSString *name = [d objectForKey:@"name"];
		NSRange range = [name rangeOfString:searchText];
		if (range.location != NSNotFound) {
			[_filteredArray addObject:d];
		}
	}
}

@dynamic array;
@synthesize style = _style;
@synthesize tableView = _tableView;

@end

