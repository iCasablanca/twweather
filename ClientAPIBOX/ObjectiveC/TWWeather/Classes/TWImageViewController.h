//
//  TWImageViewController.h
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import <UIKit/UIKit.h>


@interface TWImageViewController : UIViewController <UIScrollViewDelegate>
{
	UIImageView *_imageView;
	UIImage *_image;
}

- (IBAction)copy:(id)sender;

@property (retain, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) UIImage *image;

@end
