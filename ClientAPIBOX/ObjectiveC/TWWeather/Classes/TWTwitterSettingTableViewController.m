//
// TWTwitterSettingTableViewController.m
//
// Copyright (c) 2009 - 2010 Weizhong Yang (http://zonble.net)
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

#import "TWTwitterSettingTableViewController.h"
#import "SFHFKeychainUtils.h"
#import "TWCommonHeader.h"

@implementation TWTwitterSettingTableViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Twitter Setting", @"");
}	

- (BOOL)isLoggedIn
{
	return [TWTwitterEngine sharedEngine].loggedIn;
}
- (void)updateLoginInfo
{	
	if ([TWTwitterEngine sharedEngine].loggedIn) {
		MGTwitterEngine *engine = [TWTwitterEngine sharedEngine].engine;
		self.loginName = [engine username];
		self.password = [engine password];
	}
}

- (IBAction)loginAciton:(id)sender
{
	self.loginName = [loginNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	self.password = [passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	loginNameField.text = loginName;
	passwordField.text = password;
	
	if (![loginName length]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please input your Twitter login name.", @"") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
		[alert show];
		[alert release];
		[loginNameField becomeFirstResponder];
		return;
	}
	
	if (![password length]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please input your Twitter password.", @"") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
		[alert show];
		[alert release];
		[passwordField becomeFirstResponder];
		return;
	}
	
	[self showLoadingView];
	[TWTwitterEngine sharedEngine].delegate = self;
	MGTwitterEngine *engine = [TWTwitterEngine sharedEngine].engine;
	[engine setUsername:loginName password:password];
	self.connectionID = [engine checkUserCredentials];
}

- (IBAction)logoutAction:(id)sender
{
	MGTwitterEngine *engine = [TWTwitterEngine sharedEngine].engine;
	NSString *username = [engine username];
	NSError *error = nil;
	[SFHFKeychainUtils deleteItemForUsername:username andServiceName:TWTwitterService error:&error];
	
	[engine setUsername:@"" password:@""];
	[TWTwitterEngine sharedEngine].loggedIn = NO;
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:TWTwitterLoginNamePreference];

	[self refresh];
	[loginNameField becomeFirstResponder];
}

#pragma mark -

- (void)requestSucceeded:(NSString *)requestIdentifier
{
	[self hideLoadingView];
	[TWTwitterEngine sharedEngine].loggedIn = YES;
	
	if (loginName && password) { 
		NSError *error = nil;
		[[NSUserDefaults standardUserDefaults] setObject:loginName forKey:TWTwitterLoginNamePreference];
		[SFHFKeychainUtils storeUsername:loginName andPassword:password forServiceName:TWTwitterService updateExisting:YES error:&error];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	[self refresh];
	
	if (self.navigationItem.leftBarButtonItem) {
		UIBarButtonItem *item = self.navigationItem.leftBarButtonItem;
		SEL action = [item action];
		id target = [item target];
		[target performSelector:action withObject:self];
	}
}
- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error
{
	[self hideLoadingView];
	[loginNameField becomeFirstResponder];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to login Twitter.", @"") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", @"") otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

@synthesize connectionID;

@end
