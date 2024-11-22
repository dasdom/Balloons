//  Created by Dominik Hauser on 02.11.24.
//  
//


#import "DDHRope.h"

@interface DDHRope ()
@property (nonatomic, strong) NSArray<SKNode *> *segments;
@property (nonatomic, strong) NSArray<SKPhysicsJoint *> *joints;
@end

@implementation DDHRope
- (void)joinToStartNode:(SKNode *)startNode startAnchor:(CGPoint)startAnchor endNode:(SKNode *)endNode endAnchor:(CGPoint)endAnchor inScene:(SKScene *)scene {

    NSMutableArray<SKNode *> *segments = [[NSMutableArray alloc] init];
    CGSize segmentSize = CGSizeMake(1, 3);

    NSInteger index = 0;
    CGFloat offset = 0;
    SKNode *lastNode;
    do {
        SKShapeNode *node = [SKShapeNode shapeNodeWithRectOfSize:segmentSize];
        node.fillColor = [UIColor lightGrayColor];
        node.strokeColor = [UIColor lightGrayColor];
        offset = segmentSize.height * (index + 1);
        node.position = CGPointMake(startNode.position.x, CGRectGetMinY(startNode.frame) - offset);

        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:segmentSize];
        node.physicsBody.categoryBitMask = kNilOptions;
        node.physicsBody.collisionBitMask = kNilOptions;
        node.physicsBody.linearDamping = 0.5;
        node.physicsBody.angularDamping = 0.5;
        node.physicsBody.mass = 0.02;

        [segments addObject:node];
        [self addChild:node];
        lastNode = node;
        index++;
    } while (lastNode.position.y > endNode.position.y + 4);

    self.segments = [segments copy];

    NSMutableArray<SKPhysicsJoint *> *joints = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<[self.segments count]; i++) {

        SKNode *nodeA;
        SKNode *nodeB;
        CGPoint anchorA;
        CGPoint anchorB;
        if (i == 0) {
            nodeA = startNode;
            nodeB = self.segments[i];
            anchorA = CGPointMake(CGRectGetMidX(nodeA.frame), CGRectGetMinY(nodeA.frame));
            anchorB = [self convertPoint:CGPointMake(CGRectGetMidX(nodeB.frame), CGRectGetMinY(nodeB.frame)) toNode:scene];
        } else {
            nodeA = self.segments[i-1];
            nodeB = self.segments[i];
            anchorA = [self convertPoint:CGPointMake(CGRectGetMidX(nodeA.frame), CGRectGetMinY(nodeA.frame)) toNode:scene];
            anchorB = [self convertPoint:CGPointMake(CGRectGetMidX(nodeB.frame), CGRectGetMinY(nodeB.frame)) toNode:scene];
        }

        SKPhysicsJointPin *joint = [SKPhysicsJointPin jointWithBodyA:nodeA.physicsBody bodyB:nodeB.physicsBody anchor:anchorA];

        [joints addObject:joint];
        [scene.physicsWorld addJoint:joint];
    }

    SKNode *nodeA = self.segments.lastObject;
    CGPoint anchorA = [self convertPoint:CGPointMake(CGRectGetMidX(nodeA.frame), CGRectGetMinY(nodeA.frame)) toNode:scene];
    CGPoint anchorB = [self convertPoint:CGPointMake(CGRectGetMidX(endNode.frame), CGRectGetMinY(endNode.frame)) toNode:scene];

    SKPhysicsJointPin *joint = [SKPhysicsJointPin jointWithBodyA:nodeA.physicsBody bodyB:endNode.physicsBody anchor:anchorA];
    [joints addObject:joint];
    [scene.physicsWorld addJoint:joint];

    self.joints = [joints copy];
}

- (void)removeFromParentWithScene:(SKScene *)scene {
    for (SKPhysicsJoint *joint in self.joints) {
        [scene.physicsWorld removeJoint:joint];
    }

    for (SKNode *node in self.segments) {
        [node removeFromParent];
    }

    [super removeFromParent];
}

//- (void)adjustRingPositions {
//    //based on zRotations of all rings and the position of start ring adjust the rest of the rings positions starting from top to bottom
//    for (int i = 1; i < self.segments.count; i++) {
//        SKNode *nodeA = [self.segments objectAtIndex:i-1];
//        SKNode *nodeB = [self.segments objectAtIndex:i];
//        CGFloat thetaA = nodeA.zRotation - M_PI / 2,
//        thetaB = nodeB.zRotation + M_PI / 2,
//        jointRadius = (2.3 + 1) / 2,
//        xJoint = jointRadius * cosf(thetaA) + nodeA.position.x,
//        yJoint = jointRadius * sinf(thetaA) + nodeA.position.y,
//        theta = thetaB - M_PI,
//        xB = jointRadius * cosf(theta) + xJoint,
//        yB = jointRadius * sinf(theta) + yJoint;
//        nodeB.position = CGPointMake(xB, yB);
//    }
//}

@end
