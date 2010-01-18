//
// TWSocialSettingTableViewController.m
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

#import "TWSocialSettingTableViewController.h"
#import "TWCommonHeader.h"
#import "KeychainItemWrapper.h"

@implementation TWSocialSettingTableViewController

#pragma mark Routines

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
	[loginName release];
	[password release];
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
//	self.title = NSLocalizedString(@"Plurk Setting", @"");
	
	if (!loginNameField) {
		loginNameField = [[UITextField alloc] initWithFrame:CGRectMake(120, 15, 180, 30)];
		loginNameField.font = [UIFont systemFontOfSize:14.0];
		loginNameField.keyboardType = UIKeyboardTypeEmailAddress;
		loginNameField.autocorrectionType = UITextAutocorrectionTypeNo;
		loginNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		loginNameField.returnKeyType = UIReturnKeyNext;
		loginNameField.placeholder = NSLocalizedString(@"Your Login Name", @"");
		loginNameField.delegate = self;
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
	}
	
	loadingView = [[TWLoadingView alloc] initWithFrame:CGRectMake(100, 100, 120, 120)];	
	
	if (!loginButton)  {	
		loginButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];	
		loginButton.frame = CGRectMake(10, 30, 300, 40);
		loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
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


#pragma mark Actions

- (BOOL)isLoggedIn
{
	return NO;
}
- (void)updateLoginInfo
{
}

- (void)refresh
{
	[self updateLoginInfo];
	
	NSString *loginText = NSLocalizedString(@"Login", @"");
	[loginButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];

	if ([self isLoggedIn]) {
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
}

- (IBAction)logoutAction:(id)sender
{
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
			if ([self isLoggedIn]) {
				cell.detailTextLabel.text = loginName;
			}
			else {
				[cell addSubview:loginNameField];
			}
			break;
		case 1:
			cell.textLabel.text = NSLocalizedString(@"Password:", @"");
			if ([self isLoggedIn]) {
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

//#pragma mark -
//#pragma mark Plurk Login delegate methods.
//
//- (void)plurk:(ObjectivePlurk *)plurk didLoggedIn:(NSDictionary *)result
//{
//	[self hideLoadingView];
//
//	if (loginName && password) { 
//		[[NSUserDefaults standardUserDefaults] setObject:loginName forKey:TWPlurkLoginNamePreference];
//
//#if TARGET_IPHONE_SIMULATOR	
//		[[NSUserDefaults standardUserDefaults] setObject:password forKey:TWPlurkPasswordPreference];
//#else
//		KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:loginName accessGroup:nil];
//		[wrapper setObject:loginName forKey:(id)kSecAttrAccount];
//		[wrapper setObject:password forKey:(id)kSecValueData];
//		[wrapper release];
//#endif
//	}
//	[self refresh];
//
//	if (self.navigationItem.leftBarButtonItem) {
//		UIBarButtonItem *item = self.navigationItem.leftBarButtonItem;
//		SEL action = [item action];
//		id target = [item target];
//		[target performSelector:action withObject:self];
//	}
//
//}
//- (void)plurk:(ObjectivePlurk *)plurk didFailLoggingIn:(NSError *)error
//{
//	[self hideLoadingView];
//	[loginNameField becomeFirstResponder];
//	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to login Plurk.", @"") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
//	[alertView show];
//	[alertView release];
//}

@synthesize loginName;
@synthesize password;

@end