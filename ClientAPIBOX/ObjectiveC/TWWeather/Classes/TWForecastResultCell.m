//
//  TWForecastResultCell.m
//  TWWeather
//
//  Created by zonble on 2009/07/31.
//

#import "TWForecastResultCell.h"


@interface TWForecastResultCell (ProtectedMethods)
- (void)draw:(CGRect)bounds;
@end

@interface TWForecastResultCellContentView : UIView
{
	TWForecastResultCell *_delegate;
}
@property (assign, nonatomic) TWForecastResultCell *delegate;
@end

@implementation TWForecastResultCellContentView

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}
- (void)drawRect:(CGRect)rect
{
	[_delegate draw:self.bounds];
}

@synthesize delegate = _delegate;
@end

@implementation TWForecastResultCell

- (void)dealloc
{
	[_ourContentView removeFromSuperview];
	[_ourContentView release];
	[title release];
	[description release];
	[rain release];
	[temperature release];
	[beginTime release];
	[endTime release];
	[weatherImage release];
    [super dealloc];
}
- (void)_init
{
	CGRect cellFrame = CGRectMake(10, 5, 280.0, 110.0);
	_ourContentView.backgroundColor = [UIColor redColor];
	_ourContentView = [[TWForecastResultCellContentView alloc] initWithFrame:cellFrame];
	_ourContentView.delegate = self;
	[self.contentView addSubview:_ourContentView];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self _init];
    }
    return self;
	
}
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		[self _init];
    }
    return self;
}
- (void)draw:(CGRect)bounds
{
	if (self.highlighted || self.selected) {
		[[UIColor whiteColor] set];
	}
	else {
		[[UIColor blackColor] set];
	}
	
	[title drawInRect:CGRectMake(70, 5, 210, 20) withFont:[UIFont systemFontOfSize:14.0]];
	NSString *timeString = [NSString stringWithFormat:@"%@ - %@", beginTime, endTime];
	[timeString drawInRect:CGRectMake(70, 25, 210, 20) withFont:[UIFont systemFontOfSize:10.0]];
	[description drawInRect:CGRectMake(70, 42, 210, 30) withFont:[UIFont boldSystemFontOfSize:22.0]];
	NSString *temperatureString = [NSString stringWithFormat:@"溫度： %@ ℃", temperature];
	[temperatureString drawInRect:CGRectMake(70, 74, 210, 20) withFont:[UIFont systemFontOfSize:14.0]];
	NSString *rainString = [NSString stringWithFormat:@"降雨機率： %@ %%", rain];
	[rainString drawInRect:CGRectMake(70, 94, 210, 20) withFont:[UIFont systemFontOfSize:14.0]];
	
	CGSize size = weatherImage.size;
	[weatherImage drawInRect:CGRectMake(0, 40, size.width * 0.8, size.height * 0.8)];
}

- (void)setNeedsDisplay
{
	[_ourContentView setNeedsDisplay];
	[super setNeedsDisplay];
}

@synthesize title;
@synthesize description;
@synthesize rain;
@synthesize temperature;
@synthesize beginTime;
@synthesize endTime;
@synthesize weatherImage;

@end
