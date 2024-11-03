//  Created by Dominik Hauser on 01.11.24.
//  
//


#import "DDHBalloonAnchor.h"

@implementation DDHBalloonAnchor
+ (instancetype)anchorNode {
    CGSize size = CGSizeMake(5, 5);
    DDHBalloonAnchor *node = [super shapeNodeWithEllipseOfSize:size];
    node.fillColor = [UIColor whiteColor];

    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.mass = 99999999999;
    node.physicsBody.categoryBitMask = kNilOptions;
    return node;
}
@end
