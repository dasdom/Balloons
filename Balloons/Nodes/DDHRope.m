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
        node.physicsBody.mass = 0.1;

        [segments addObject:node];
        [self addChild:node];
        lastNode = node;
        index++;
    } while (lastNode.position.y > endNode.position.y);

    self.segments = [segments copy];

    NSMutableArray<SKPhysicsJoint *> *joints = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<[self.segments count]; i++) {

        SKNode *nodeA;
        SKNode *nodeB;
        CGPoint anchor;
        if (i == 0) {
            nodeA = startNode;
            nodeB = self.segments[i];
            anchor = CGPointMake(CGRectGetMidX(nodeA.frame), CGRectGetMinY(nodeA.frame));
        } else {
            nodeA = self.segments[i-1];
            nodeB = self.segments[i];
            anchor = [self convertPoint:CGPointMake(CGRectGetMidX(nodeA.frame), CGRectGetMinY(nodeA.frame)) toNode:scene];
        }

        SKPhysicsJointPin *joint = [SKPhysicsJointPin jointWithBodyA:nodeA.physicsBody bodyB:nodeB.physicsBody anchor:anchor];

        [joints addObject:joint];
        [scene.physicsWorld addJoint:joint];
    }

    SKNode *nodeA = self.segments.lastObject;
    CGPoint anchor = [self convertPoint:CGPointMake(CGRectGetMidX(nodeA.frame), CGRectGetMinY(nodeA.frame)) toNode:scene];

    SKPhysicsJoint *joint = [SKPhysicsJointPin jointWithBodyA:nodeA.physicsBody bodyB:endNode.physicsBody anchor:anchor];
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

@end
