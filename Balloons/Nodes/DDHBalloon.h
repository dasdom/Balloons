//  Created by Dominik Hauser on 27.10.24.
//  
//


#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHBalloon : SKSpriteNode
@property (nonatomic, strong) NSUUID *birthdayId;
- (instancetype)initWithImage:(NSData *)imageData width:(CGFloat)width birthdayId:(NSUUID *)birthdayId;
- (DDHBalloon *)balloonCopy;
@end

NS_ASSUME_NONNULL_END
