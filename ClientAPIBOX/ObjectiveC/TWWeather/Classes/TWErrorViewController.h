//
//  TWErrorViewController.h
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import <UIKit/UIKit.h>


@interface TWErrorViewController : UIViewController 
{
	NSError *_error;
	UILabel *textLabel;
}

@property (assign, nonatomic) NSError *error;

@end
