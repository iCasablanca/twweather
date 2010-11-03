//
//  TWFacebookController.m
//  TWWeather
//
//  Created by zonble on 1/30/10.
//  Copyright 2010 Lithoglyph Inc.. All rights reserved.
//

#import "TWFacebookController.h"
#import "TWWeatherAppDelegate.h"

@implementation TWFacebookController

- (void)removeOutletsAndControls_TWFacebookController
{
    // remove and clean outlets and controls here
}

- (void)dealloc 
{
	[self removeOutletsAndControls_TWFacebookController];
	[posts release];
    [super dealloc];
}
- (void)viewDidUnload
{
	[super viewDidUnload];
	[self removeOutletsAndControls_TWFacebookController];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

/*
// The designated initializer.  Override if you create the controller
// programmatically and want to perform customization that is not appropriate 
// for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

#pragma mark -
#pragma mark UIViewContoller Methods

/*
// Implement loadView to create a view hierarchy programmatically, without
// using a nib.
- (void)loadView 
{
}
*/
- (void)viewDidLoad 
{
    [super viewDidLoad];
	if (!posts) {
		posts = [[NSMutableArray alloc] init];
	}
				 
	
	NSMutableDictionary *args = [[[NSMutableDictionary alloc] init] autorelease];
//	[args setObject:self.title forKey:@"caption"];		
	[args setObject:@"188341743092" forKey:@"source_ids"];
	FBRequest *request = [FBRequest requestWithDelegate:self];
	[request call:@"stream.get" params:args];
	
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
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

	// Release any cached data, images, etc that aren't in use.
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [posts count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	NSDictionary *item = [posts objectAtIndex:indexPath.row];
	cell.textLabel.text = [item valueForKey:@"message"];
	
    // Set up the cell...

    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)aCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Remenber to redraw the cell if you used a customized one.
	[aCell setNeedsDisplay];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return nil;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0;
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/
/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)requestLoading:(FBRequest*)request
{
}
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response
{
}
- (void)request:(FBRequest*)request didLoad:(id)result
{
	NSLog(@"result:%@", [result description]);
	[posts addObjectsFromArray:[result valueForKey:@"posts"]];
	[self.tableView reloadData];
}
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
	NSLog(@"error:%@", [error description]);
	
//	FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] init] autorelease];
//	dialog.delegate = self;
//	dialog.permission = @"read_stream";
//	[dialog show];
}

@end

