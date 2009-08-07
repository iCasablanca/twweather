//
// TWAPIBox+Info.m
//
// Copyright (c) 2009 Weizhong Yang (http://zonble.net)
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import "TWAPIBox+Info.h"

@interface TWAPIBox(Private_Info)
- (void)initForecastLocations;
- (void)initWeekLocations;
- (void)initWeekTravelLocations;
- (void)initThreeDaySeaLocations;
- (void)initNearSeaLocations;
- (void)initTideLocations;
- (void)initImageIdentifiers;
@end

@implementation TWAPIBox(Private_Info)

- (void)addToArray:(NSMutableArray *)array name:(char *)name identifier:(NSString *)identifier
{
	NSString *nameString = [NSString stringWithUTF8String:name];
	[array addObject:[NSDictionary dictionaryWithObjectsAndKeys:identifier, @"identifier", nameString, @"name", nil]];
}

- (void)initForecastLocations
{
	_forecastLocations = [[NSMutableArray alloc] init];	
	[self addToArray:_forecastLocations name:"台北市" identifier:@"1"];
	[self addToArray:_forecastLocations name:"高雄市" identifier:@"2"];
	[self addToArray:_forecastLocations name:"基隆" identifier:@"3"];
	[self addToArray:_forecastLocations name:"台北" identifier:@"4"];
	[self addToArray:_forecastLocations name:"桃園" identifier:@"5"];
	[self addToArray:_forecastLocations name:"新竹" identifier:@"6"];
	[self addToArray:_forecastLocations name:"苗栗" identifier:@"7"];
	[self addToArray:_forecastLocations name:"台中" identifier:@"8"];
	[self addToArray:_forecastLocations name:"彰化" identifier:@"9"];
	[self addToArray:_forecastLocations name:"南投" identifier:@"10"];
	[self addToArray:_forecastLocations name:"雲林" identifier:@"11"];
	[self addToArray:_forecastLocations name:"嘉義" identifier:@"12"];
	[self addToArray:_forecastLocations name:"台南" identifier:@"13"];
	[self addToArray:_forecastLocations name:"高雄" identifier:@"14"];
	[self addToArray:_forecastLocations name:"屏東" identifier:@"15"];
	[self addToArray:_forecastLocations name:"恆春" identifier:@"16"];
	[self addToArray:_forecastLocations name:"宜蘭" identifier:@"17"];
	[self addToArray:_forecastLocations name:"花蓮" identifier:@"18"];
	[self addToArray:_forecastLocations name:"台東" identifier:@"19"];
	[self addToArray:_forecastLocations name:"澎湖" identifier:@"20"];
	[self addToArray:_forecastLocations name:"金門" identifier:@"21"];
	[self addToArray:_forecastLocations name:"馬祖" identifier:@"22"];
}
- (void)initWeekLocations
{
	_weekLocations = [[NSMutableArray alloc] init];
	[self addToArray:_weekLocations name:"台北市" identifier:@"Taipei"];
	[self addToArray:_weekLocations name:"北部" identifier:@"North"];
	[self addToArray:_weekLocations name:"中部" identifier:@"Center"];
	[self addToArray:_weekLocations name:"南部" identifier:@"South"];
	[self addToArray:_weekLocations name:"東北部" identifier:@"North-East"];
	[self addToArray:_weekLocations name:"東部" identifier:@"East"];
	[self addToArray:_weekLocations name:"東南部" identifier:@"South-East"];
	[self addToArray:_weekLocations name:"澎湖" identifier:@"Penghu"];
	[self addToArray:_weekLocations name:"金門" identifier:@"Kinmen"];
	[self addToArray:_weekLocations name:"馬祖" identifier:@"Matsu"];
}
- (void)initWeekTravelLocations
{
	_weekTravelLocations = [[NSMutableArray alloc] init];
	[self addToArray:_weekTravelLocations name:"陽明山" identifier:@"Yang-ming-shan"];
	[self addToArray:_weekTravelLocations name:"拉拉山" identifier:@"Lalashan"];
	[self addToArray:_weekTravelLocations name:"梨山" identifier:@"Lishan"];
	[self addToArray:_weekTravelLocations name:"合歡山" identifier:@"Hohuan-shan"];
	[self addToArray:_weekTravelLocations name:"日月潭" identifier:@"Sun-Moon-Lake"];
	[self addToArray:_weekTravelLocations name:"溪頭" identifier:@"Hsitou"];
	[self addToArray:_weekTravelLocations name:"阿里山" identifier:@"Alishan"];
	[self addToArray:_weekTravelLocations name:"玉山" identifier:@"Yushan"];
	[self addToArray:_weekTravelLocations name:"墾丁" identifier:@"Kenting"];
	[self addToArray:_weekTravelLocations name:"龍洞" identifier:@"Lung-tung"];
	[self addToArray:_weekTravelLocations name:"太魯閣" identifier:@"Taroko"];
	[self addToArray:_weekTravelLocations name:"三仙台" identifier:@"San-shiantai"];
	[self addToArray:_weekTravelLocations name:"綠島" identifier:@"Lu-Tao"];
	[self addToArray:_weekTravelLocations name:"蘭嶼" identifier:@"Lanyu"];
}
- (void)initThreeDaySeaLocations
{
	_threeDaySeaLocations = [[NSMutableArray alloc] init];
	[self addToArray:_threeDaySeaLocations name:"黃海南部海面" identifier:@"1"];
	[self addToArray:_threeDaySeaLocations name:"花鳥山海面" identifier:@"2"];
	[self addToArray:_threeDaySeaLocations name:"東海北部海面" identifier:@"3"];
	[self addToArray:_threeDaySeaLocations name:"浙江海面" identifier:@"4"];
	[self addToArray:_threeDaySeaLocations name:"東海南部海面" identifier:@"5"];
	[self addToArray:_threeDaySeaLocations name:"台灣北部海面" identifier:@"6"];
	[self addToArray:_threeDaySeaLocations name:"台灣海峽北部" identifier:@"7"];
	[self addToArray:_threeDaySeaLocations name:"台灣海峽南部" identifier:@"8"];
	[self addToArray:_threeDaySeaLocations name:"台灣東北部海面" identifier:@"9"];
	[self addToArray:_threeDaySeaLocations name:"台灣東南部海面" identifier:@"10"];
	[self addToArray:_threeDaySeaLocations name:"巴士海峽" identifier:@"11"];
	[self addToArray:_threeDaySeaLocations name:"廣東海面" identifier:@"12"];
	[self addToArray:_threeDaySeaLocations name:"東沙島海面" identifier:@"13"];
	[self addToArray:_threeDaySeaLocations name:"中西沙島海面" identifier:@"14"];
	[self addToArray:_threeDaySeaLocations name:"南沙島海面" identifier:@"15"];
}
- (void)initNearSeaLocations
{
	_nearSeaLocations = [[NSMutableArray alloc] init];
	[self addToArray:_nearSeaLocations name:"釣魚台海面" identifier:@"1"];
	[self addToArray:_nearSeaLocations name:"彭佳嶼基隆海面" identifier:@"2"];
	[self addToArray:_nearSeaLocations name:"宜蘭蘇澳沿海" identifier:@"3"];
	[self addToArray:_nearSeaLocations name:"新竹鹿港沿海" identifier:@"4"];
	[self addToArray:_nearSeaLocations name:"澎湖海面" identifier:@"5"];
	[self addToArray:_nearSeaLocations name:"鹿港東石沿海" identifier:@"6"];
	[self addToArray:_nearSeaLocations name:"東石安平沿海" identifier:@"7"];
	[self addToArray:_nearSeaLocations name:"安平高雄沿海" identifier:@"8"];
	[self addToArray:_nearSeaLocations name:"高雄枋寮沿海" identifier:@"9"];
	[self addToArray:_nearSeaLocations name:"枋寮恆春沿海" identifier:@"10"];
	[self addToArray:_nearSeaLocations name:"鵝鑾鼻沿海" identifier:@"11"];
	[self addToArray:_nearSeaLocations name:"成功大武沿海" identifier:@"12"];
	[self addToArray:_nearSeaLocations name:"綠島蘭嶼海面" identifier:@"13"];
	[self addToArray:_nearSeaLocations name:"花蓮沿海" identifier:@"14"];
	[self addToArray:_nearSeaLocations name:"金門海面" identifier:@"15"];
	[self addToArray:_nearSeaLocations name:"馬祖海面" identifier:@"16"];
}
- (void)initTideLocations
{
	_tideLocations = [[NSMutableArray alloc] init];
	[self addToArray:_tideLocations name:"基隆" identifier:@"1"];
	[self addToArray:_tideLocations name:"福隆" identifier:@"2"];
	[self addToArray:_tideLocations name:"鼻頭角" identifier:@"3"];
	[self addToArray:_tideLocations name:"石門" identifier:@"4"];
	[self addToArray:_tideLocations name:"淡水" identifier:@"5"];
	[self addToArray:_tideLocations name:"大園" identifier:@"6"];
	[self addToArray:_tideLocations name:"新竹" identifier:@"7"];
	[self addToArray:_tideLocations name:"苗栗" identifier:@"8"];
	[self addToArray:_tideLocations name:"梧棲" identifier:@"9"];
	[self addToArray:_tideLocations name:"王功" identifier:@"10"];
	[self addToArray:_tideLocations name:"台西" identifier:@"11"];
	[self addToArray:_tideLocations name:"東石" identifier:@"12"];
	[self addToArray:_tideLocations name:"將軍" identifier:@"13"];
	[self addToArray:_tideLocations name:"安平" identifier:@"14"];
	[self addToArray:_tideLocations name:"高雄" identifier:@"15"];
	[self addToArray:_tideLocations name:"東港" identifier:@"16"];
	[self addToArray:_tideLocations name:"南灣" identifier:@"17"];
	[self addToArray:_tideLocations name:"澎湖" identifier:@"18"];
	[self addToArray:_tideLocations name:"蘇澳" identifier:@"19"];
	[self addToArray:_tideLocations name:"頭城" identifier:@"10"];
	[self addToArray:_tideLocations name:"花蓮" identifier:@"21"];
	[self addToArray:_tideLocations name:"台東" identifier:@"22"];
	[self addToArray:_tideLocations name:"成功" identifier:@"23"];
	[self addToArray:_tideLocations name:"蘭嶼" identifier:@"24"];
	[self addToArray:_tideLocations name:"馬祖" identifier:@"25"];
	[self addToArray:_tideLocations name:"金門" identifier:@"26"];
}
- (void)initImageIdentifiers
{
	_imageIdentifiers = [[NSMutableArray alloc] init];
	[self addToArray:_imageIdentifiers name:"雨量累積圖" identifier:@"rain"];
	[self addToArray:_imageIdentifiers name:"雷達示波圖" identifier:@"radar"];
	[self addToArray:_imageIdentifiers name:"台灣彩色天氣雲圖" identifier:@"color_taiwan"];
	[self addToArray:_imageIdentifiers name:"亞洲彩色天氣雲圖" identifier:@"color_asia"];
	[self addToArray:_imageIdentifiers name:"台灣色彩強化天氣雲圖" identifier:@"hilight_taiwan"];
	[self addToArray:_imageIdentifiers name:"亞洲色彩強化天氣雲圖" identifier:@"hilight_asia"];
}

@end

@implementation TWAPIBox(Info)

- (void)initInfoArrays
{
	[self initForecastLocations];
	[self initWeekLocations];
	[self initWeekTravelLocations];
	[self initThreeDaySeaLocations];
	[self initNearSeaLocations];
	[self initTideLocations];
	[self initImageIdentifiers];
}
- (void)releaseInfoArrays
{
	[_forecastLocations release];
	[_weekLocations release];
	[_weekTravelLocations release];
	[_threeDaySeaLocations release];
	[_nearSeaLocations release];
	[_tideLocations release];
	[_imageIdentifiers release];
}
- (NSArray *)forecastLocations
{
	return _forecastLocations;
}
- (NSArray *)weekLocations
{
	return _weekLocations;
}
- (NSArray *)weekTravelLocations
{
	return _weekTravelLocations;
}
- (NSArray *)threeDaySeaLocations
{
	return _threeDaySeaLocations;
}
- (NSArray *)nearSeaLocations
{
	return _nearSeaLocations;
}
- (NSArray *)tideLocations
{
	return _tideLocations;
}
- (NSArray *)imageIdentifiers
{
	return _imageIdentifiers;
}

@end
