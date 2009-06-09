//
//  ZBGraphicsLIstTableViewCell.h
//  TWWeather
//
//  Created by zonble on 2009/1/14.
//  Copyright 2009 zonble.twbbs.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBGraphicsListTableViewCell;

@interface ZBGraphicsListTableViewCellContentView : UIView {
	ZBGraphicsListTableViewCell *_delegate;
}

@property (readwrite, assign, nonatomic) id delegate;
@end

@interface ZBGraphicsListTableViewCell : UITableViewCell {
	ZBGraphicsListTableViewCellContentView *_graphicContentView;	
	NSString *_graphicTitle;
	UIImage *_graphicImage;	
}

@property (readwrite, retain, nonatomic) NSString *graphicTitle;
@property (readwrite, retain, nonatomic) UIImage *graphicImage;


@end
