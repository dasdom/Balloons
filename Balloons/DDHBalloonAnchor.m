//  Created by Dominik Hauser on 01.11.24.
//  
//


#import "DDHBalloonAnchor.h"

@implementation DDHBalloonAnchor
+ (instancetype)anchorNode {
    CGRect rect = CGRectMake(0, 0, 2, 6);
    DDHBalloonAnchor *node = [super shapeNodeWithRect:rect];
    node.fillColor = [UIColor whiteColor];
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect.size];
    node.physicsBody.fieldBitMask = 1 << 2;
    node.physicsBody.dynamic = false;
    return node;
}
@end
