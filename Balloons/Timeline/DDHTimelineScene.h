//  Created by Dominik Hauser on 27.10.24.
//  
//


#import <SpriteKit/SpriteKit.h>

@class DDHBirthday;

@interface DDHTimelineScene : SKScene
- (instancetype)initWithSize:(CGSize)size;
- (void)updateForBirthdays:(NSArray<DDHBirthday *> *)birthdays;
- (void)updateWithSize:(CGSize)size;
- (void)toggleGravityDirection;
- (void)pointGravityDown;
- (void)pointGravityUp;
- (void)setNumberOfShownDays:(NSInteger)numberOfShownDays;
@end
