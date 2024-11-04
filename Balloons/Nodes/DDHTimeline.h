//  Created by Dominik Hauser on 29.10.24.
//  
//


#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHTimeline : SKShapeNode
- (instancetype)initWithStartPoint:(CGPoint)start andEndPoint:(CGPoint)end;
- (void)updateWithStartPoint:(CGPoint)start andEndPoint:(CGPoint)end;
@end

NS_ASSUME_NONNULL_END
