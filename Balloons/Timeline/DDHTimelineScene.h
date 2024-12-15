//  Created by Dominik Hauser on 27.10.24.
//  
//


#import <SpriteKit/SpriteKit.h>
#import "DDHTimelineSceneProtocol.h"

@class DDHBirthday;

@interface DDHTimelineScene : SKScene
- (instancetype)initWithSize:(CGSize)size timelineDelegate:(id<DDHTimelineSceneProtocol>)timelineDelegate;
- (void)updateForBirthdays:(NSArray<DDHBirthday *> *)birthdays;
- (void)updateWithSize:(CGSize)size;
- (void)toggleGravityDirection;
- (void)pointGravityDown;
- (void)pointGravityUp;
- (void)setNumberOfShownDays:(NSInteger)numberOfShownDays;
@end
