#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import "TWAPIBox.h"
#import "TWAPIBox+Info.h"

@interface TWAPITest : SenTestCase 

- (void)testAPI;
- (void)testForecasts;
- (void)testWeek;
- (void)testWeekTravel;
- (void)testThreeDaySea;
- (void)testNearSea;
- (void)testTide;

@end
