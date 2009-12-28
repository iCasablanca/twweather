//
// TWPlurkSettingTableViewController.m
//
// Copyright (c) 2009 Weizhong Yang (http://zonble.net)
// All Rights Reserved
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of Weizhong Yang (zonble) nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY WEIZHONG YANG ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL WEIZHONG YANG BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
	[loadingView release];
	loadingView = nil;
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
	
	loadingView = [[TWLoadingView alloc] initWithFrame:CGRectMake(100, 100, 120, 120)];	
	
	if (!loginButton)  {	
		loginButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];	
		loginButton.frame = CGRectMake(10, 30, 300, 40);
		UIImage *blueButtonImage = [[UIImage imageNamed:@"BlueButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
		[loginButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
	}
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
	
	[self showLoadingView];
	[[ObjectivePlurk sharedInstance] loginWithUsername:loginName password:password delegate:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:loginName, @"loginName", password, @"password", nil]];
}

- (IBAction)logoutAction:(id)sender
{
	[[ObjectivePlurk sharedInstance] logout];
	[self refresh];
	[loginNameField becomeFirstResponder];
}

- (void)showLoadingView
{
	[self.view addSubview:loadingView];
	[loadingView startAnimating];
	self.tableView.userInteractionEnabled = NO;
	loginNameField.enabled = NO;
	passwordField.enabled = NO;
}
- (void)hideLoadingView
{
	[loadingView removeFromSuperview];
	[loadingView stopAnimating];
	self.tableView.userInteractionEnabled = YES;
	loginNameField.enabled = YES;
	passwordField.enabled = YES;
}

#pragma mark -
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

#pragma mark Plurk Login delegate methods.

- (void)plurk:(ObjectivePlurk *)plurk didLoggedIn:(NSDictionary *)result
{
	[self hideLoadingView];

	NSString *loginName = [loginNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *password = [passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[[NSUserDefaults standardUserDefaults] setObject:loginName forKey:TWPlurkLoginNamePreference];
	[[NSUserDefaults standardUserDefaults] setObject:password forKey:TWPlurkPasswordPreference];
	
	[self refresh];
	
	if (self.navigationItem.leftBarButtonItem) {
		UIBarButtonItem *item = self.navigationItem.leftBarButtonItem;
		SEL action = [item action];
		id target = [item target];
		[target performSelector:action withObject:self];
	}

}
- (void)plurk:(ObjectivePlurk *)plurk didFailLoggingIn:(NSError *)error
{
	[self hideLoadingView];
	[loginNameField becomeFirstResponder];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to login Plurk.", @"") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
	[alertView show];
	[alertView release];	
//	[self refresh];
}
	 

@end



