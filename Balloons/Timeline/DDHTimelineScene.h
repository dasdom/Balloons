//  Created by Dominik Hauser on 27.10.24.
//  
//


#import <SpriteKit/SpriteKit.h>
#import "DDHTimelineSceneProtocol.h"
#import "DDHBalloonPresentableProtocol.h"

@class DDHBirthday;

@interface DDHTimelineScene : SKScene
- (instancetype)initWithSize:(CGSize)size timelineDelegate:(id<DDHTimelineSceneProtocol>)timelineDelegate;
- (void)updateForItems:(NSArray<id<DDHBalloonPresentableProtocol>> *)items;
- (void)insertItem:(id<DDHBalloonPresentableProtocol>)item;
- (void)updateWithSize:(CGSize)size;
- (void)toggleGravityDirection;
- (void)pointGravityDown;
- (void)pointGravityUp;
- (void)setNumberOfShownDays:(NSInteger)numberOfShownDays;
@end
