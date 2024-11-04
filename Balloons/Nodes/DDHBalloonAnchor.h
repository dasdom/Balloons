//  Created by Dominik Hauser on 01.11.24.
//  
//


#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHBalloonAnchor : SKShapeNode
@property (assign) NSInteger daysLeft;
+ (instancetype)anchorNodeWithDaysLeft:(NSInteger)daysLeft;
@end

NS_ASSUME_NONNULL_END
