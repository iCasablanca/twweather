//
//  TWImageViewController.h
//  TWWeather
//
//  Created by zonble on 2009/08/01.
//

#import "FBconnect/FBConnect.h"

@interface TWImageViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate>
{
	UIImageView *_imageView;
	UIImage *_image;
	NSURL *_imageURL;
}

- (IBAction)navBarAction:(id)sender;
- (void)shareImageViaFacebook;
- (void)copy;

@property (retain, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) UIImage *image;
@property (retain, nonatomic) NSURL *imageURL;

@end
