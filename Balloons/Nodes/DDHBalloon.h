//  Created by Dominik Hauser on 27.10.24.
//  
//


#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHBalloon : SKSpriteNode
@property (assign) NSInteger daysLeft;
- (instancetype)initWithImage:(NSData *)imageData width:(CGFloat)width daysLeft:(NSInteger)daysLeft;
@end

NS_ASSUME_NONNULL_END
