//
// TWTwitterSettingTableViewController.m
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

#import "TWTwitterSettingTableViewController.h"
#import "TWWeatherAppDelegate.h"

@implementation TWTwitterSettingTableViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Twitter Setting", @"");
}	

- (BOOL)isLoggedIn
{
//	return [[ObjectivePlurk sharedInstance] isLoggedIn];
	return NO;
}
- (void)updateLoginInfo
{
//	NSString *theLoginName = [[NSUserDefaults standardUserDefaults] stringForKey:TWPlurkLoginNamePreference];
//	
//	if (theLoginName) {
//		self.loginName = theLoginName;	
//#if TARGET_IPHONE_SIMULATOR	
//		NSString *thePassword = [[NSUserDefaults standardUserDefaults] stringForKey:TWPlurkPasswordPreference];
//		self.password = thePassword;
//#else
//		KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:loginName accessGroup:nil];
//		NSString *thePassword = [wrapper objectForKey:(id)kSecValueData];
//		[wrapper release];
//		self.password  = thePassword;
//#endif
//	}
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
	TWTwitterEngine *engine = [TWWeatherAppDelegate sharedDelegate].twitterEngine;
	[engine setUsername:loginName password:password];
	NSString *s = [engine checkUserCredentials];
	NSLog(@"s:%@", s);
	
//	[[ObjectivePlurk sharedInstance] loginWithUsername:loginName password:password delegate:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:loginName, @"loginName", password, @"password", nil]];
}

- (IBAction)logoutAction:(id)sender
{
//	[[ObjectivePlurk sharedInstance] logout];
	[self refresh];
	[loginNameField becomeFirstResponder];
}

@end
