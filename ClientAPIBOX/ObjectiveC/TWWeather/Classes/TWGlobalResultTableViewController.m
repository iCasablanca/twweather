//
// TWGlobalResultTableViewController.m
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

#import "TWGlobalResultTableViewController.h"

@implementation TWGlobalResultTableViewController

- (void)dealloc 
{
	[image release];
	[description release];
	[temperature release];
	[avgTemperature release];
	[avgRain release];
	[pubDate release];
	[validDate release];
    [super dealloc];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.tableView.separatorColor = [UIColor whiteColor];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *ImageCellIdentifier = @"ImageCell";
	
	if (indexPath.row == 0) {
		UITableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:ImageCellIdentifier];
		if (imageCell == nil) {
			imageCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ImageCellIdentifier] autorelease];
		}
		imageCell.imageView.image = self.image;
		return imageCell;
	}
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	switch (indexPath.row) {
		case 0:
			break;
		case 1:
			cell.textLabel.text = @"天氣";
			cell.detailTextLabel.text = description;
			break;
		case 2:
			cell.textLabel.text = @"溫度";
			cell.detailTextLabel.text = temperature;
			break;
		case 3:
			cell.textLabel.text = @"月平均溫度";
			if ([avgTemperature length]) {
				cell.detailTextLabel.text = avgTemperature;
			}
			else {
				cell.detailTextLabel.text = @"N/A";
			}
			break;
		case 4:
			cell.textLabel.text = @"月平均降雨";
			if ([avgRain length]) {
				cell.detailTextLabel.text = avgRain;
			}
			else {
				cell.detailTextLabel.text = @"N/A";
			}
			break;
		default:
			break;
	}
	
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if (![pubDate length]) {
		return nil;
	}
	
	NSMutableString *s = [NSMutableString string];
	[s appendFormat:NSLocalizedString(@"Published at: %@\n", @""), pubDate];
	[s appendString:validDate];
	return s;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
		return 120.0;
	}	
	return 44.0;
}


@synthesize image;
@synthesize description;
@synthesize temperature;
@synthesize avgTemperature;
@synthesize avgRain;
@synthesize pubDate;
@synthesize validDate;
@end

