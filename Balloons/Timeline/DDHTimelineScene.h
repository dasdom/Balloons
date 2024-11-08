//  Created by Dominik Hauser on 27.10.24.
//  
//


#import <SpriteKit/SpriteKit.h>

@class DDHBirthday;

@protocol DDHTimelineSceneTouchHandler <NSObject>
- (void)didTouchBirthdayWithId:(NSUUID *)birthdayId;
@end

@interface DDHTimelineScene : SKScene
- (instancetype)initWithSize:(CGSize)size touchHandler:(id<DDHTimelineSceneTouchHandler>)touchHandler;
- (void)updateForBirthdays:(NSArray<DDHBirthday *> *)birthdays;
- (void)updateWithSize:(CGSize)size;
@end
