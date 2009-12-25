//
//  TWPlurkSettingTableViewController.m
//  TWWeather
//
//  Created by zonble on 12/26/09.
//  Copyright 2009 Lithoglyph Inc.. All rights reserved.
//

#import "TWPlurkSettingTableViewController.h"
#import "TWCommonHeader.h"

@implementation TWPlurkSettingTableViewController

- (void)removeOutletsAndControls_TWPlurkSettingTableViewController
{
	[loginNameField release];
	loginNameField = nil;
	[passwordField release];
	passwordField = nil;
	[loginButton release];
	loginButton = nil;
}

- (void)dealloc 
{
	[self removeOutletsAndControls_TWPlurkSettingTableViewController];
    [super dealloc];
}
- (void)viewDidUnload
{
	[super viewDidUnload];
	[self removeOutletsAndControls_TWPlurkSettingTableViewController];
}

#pragma mark -
#pragma mark UIViewContoller Methods

- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Plurk Setting", @"");
	
	if (!loginNameField) {
		loginNameField = [[UITextField alloc] initWithFrame:CGRectMake(120, 15, 180, 30)];
		loginNameField.font = [UIFont systemFontOfSize:14.0];
		loginNameField.keyboardType = UIKeyboardTypeEmailAddress;
		loginNameField.autocorrectionType = UITextAutocorrectionTypeNo;
		loginNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		loginNameField.returnKeyType = UIReturnKeyNext;
		loginNameField.placeholder = NSLocalizedString(@"Your Login Name", @"");
		loginNameField.delegate = self;
		NSString *loginName = [[NSUserDefaults standardUserDefaults] stringForKey:TWPlurkLoginNamePreference];
		if (loginName) {
			loginNameField.text = loginName;
		}
	}

	if (!passwordField) {
		passwordField = [[UITextField alloc] initWithFrame:CGRectMake(120, 15, 180, 30)];
		passwordField.font = [UIFont systemFontOfSize:14.0];
		passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
		passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		passwordField.returnKeyType = UIReturnKeyDone;
		passwordField.placeholder = NSLocalizedString(@"Your Password", @"");
		passwordField.secureTextEntry = YES;
		passwordField.delegate = self;
		NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:TWPlurkPasswordPreference];
		passwordField.text = password;
	}
	
	loginButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];	
	loginButton.frame = CGRectMake(10, 30, 300, 40);
	self.tableView.tableFooterView = loginButton;
	self.tableView.scrollEnabled = NO;
	
	[self refresh];
}
- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	
	if (![[ObjectivePlurk sharedInstance] isLoggedIn]) {
		[loginNameField becomeFirstResponder];
	}
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
}

- (void)refresh
{
	NSString *loginText = NSLocalizedString(@"Login", @"");
	[loginButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];

	if ([[ObjectivePlurk sharedInstance] isLoggedIn]) {
		loginText =  NSLocalizedString(@"Logout", @"");
		[loginButton addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
		loginNameField.enabled = NO;
		passwordField.enabled = NO;
		[loginNameField removeFromSuperview];
		[passwordField removeFromSuperview];
	}
	else {
		[loginButton addTarget:self action:@selector(loginAciton:) forControlEvents:UIControlEventTouchUpInside];
		loginNameField.enabled = YES;
		passwordField.enabled = YES;
		loginNameField.text = @"";
		passwordField.text = @"";
	}
	
	[loginButton setTitle:loginText forState:UIControlStateNormal];
	[loginButton setTitle:loginText forState:UIControlStateHighlighted];
	[loginButton setTitle:loginText forState:UIControlStateDisabled];
	[loginButton setTitle:loginText forState:UIControlStateSelected];
	
	[self.tableView reloadData];
}

- (IBAction)loginAciton:(id)sender
{
	NSString *loginName = [loginNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *password = [passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	loginNameField.text = loginName;
	passwordField.text = password;
	
	if (![loginName length]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please input your Plurk login name.", @"") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
		[alert show];
		[alert release];
		[loginNameField becomeFirstResponder];
		return;
	}
	
	if (![password length]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please input your Plurk password.", @"") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
		[alert show];
		[alert release];
		[passwordField becomeFirstResponder];
		return;
	}
	
	[[ObjectivePlurk sharedInstance] loginWithUsername:loginName password:password delegate:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:loginName, @"loginName", password, @"password", nil]];
}

- (IBAction)logoutAction:(id)sender
{
	[[ObjectivePlurk sharedInstance] logout];
	[self refresh];
	[loginNameField becomeFirstResponder];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.detailTextLabel.text = nil;
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = NSLocalizedString(@"Login Name:", @"");
			if ([[ObjectivePlurk sharedInstance] isLoggedIn]) {
				NSString *loginName = [[NSUserDefaults standardUserDefaults] stringForKey:TWPlurkLoginNamePreference];
				cell.detailTextLabel.text = loginName;
			}
			else {
				[cell addSubview:loginNameField];
			}
			break;
		case 1:
			cell.textLabel.text = NSLocalizedString(@"Password:", @"");
			if ([[ObjectivePlurk sharedInstance] isLoggedIn]) {
				NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:TWPlurkPasswordPreference];
				NSMutableString *s = [NSMutableString string];
				for (NSInteger i = 0; i < [password length]; i++) {
					[s appendString:@"*"];
				}
				cell.detailTextLabel.text = s;
			}
			else {
				[cell addSubview:passwordField];
			}
			break;
			
		default:
			break;
	}

    // Set up the cell...

    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == loginNameField) {
		[passwordField becomeFirstResponder];
	}
	else if (textField == passwordField) {
		[self loginAciton:self];
	}	
	return YES;
}

- (void)plurk:(ObjectivePlurk *)plurk didLoggedIn:(NSDictionary *)result
{
	NSString *loginName = [loginNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *password = [passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[[NSUserDefaults standardUserDefaults] setObject:loginName forKey:TWPlurkLoginNamePreference];
	[[NSUserDefaults standardUserDefaults] setObject:password forKey:TWPlurkPasswordPreference];
	[self refresh];
}
- (void)plurk:(ObjectivePlurk *)plurk didFailLoggingIn:(NSError *)error
{
	[self refresh];
}
	 

@end



