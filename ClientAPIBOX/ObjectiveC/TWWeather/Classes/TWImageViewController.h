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

@property (retain, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) UIImage *image;

@end
