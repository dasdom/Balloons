//  Created by Dominik Hauser on 02.11.24.
//  
//


#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHRope : SKNode
- (void)joinToStartNode:(SKNode *)startNode startAnchor:(CGPoint)startAnchor endNode:(SKNode *)endNode endAnchor:(CGPoint)endAnchor inScene:(SKScene *)scene;
- (void)removeFromParentWithScene:(SKScene *)scene;
@end

NS_ASSUME_NONNULL_END
