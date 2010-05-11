//
// TWFavoriteTableViewController.h
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

#import <iAd/iAd.h>

#import "TWLocationSettingTableViewController.h"
#import "TWLoadingView.h"

@interface TWFavoriteTableViewController : UITableViewController <TWLocationSettingTableViewControllerDelegate, ADBannerViewDelegate>
{
	ADBannerView *bannerView;
	
	NSMutableArray *_filterArray;
	NSMutableArray *_filteredArray;
	NSMutableArray *_favArray;
	NSMutableArray *warningArray;
	NSMutableDictionary *weekDictionary;
	NSDate *updateDate;
	
	TWLoadingView *loadingView;
	UITableView *_tableView;
	UILabel *errorLabel;
	
	BOOL dataLoaded;
	BOOL isLoading;
	BOOL isLoadingWeek;
	NSUInteger loadingWeekIndex;
	
	NSDate *lastCheckDate;
}

- (void)updateFilteredArray;
- (void)loadData;
- (void)showLoadingView;
- (void)hideLoadingView;

- (IBAction)changeSetting:(id)sender;
- (IBAction)reload:(id)sender;

@property (retain, nonatomic) NSDate *updateDate;
@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) NSDate *lastCheckDate;

@end
