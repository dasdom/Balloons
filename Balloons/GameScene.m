//  Created by Dominik Hauser on 27.10.24.
//  
//


#import "GameScene.h"
#import "DDHBalloon.h"
#import "DDHTimeline.h"

@implementation GameScene {
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
}

- (instancetype)init {
    if (self = [super initWithSize:CGSizeMake(750, 1334)]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.physicsWorld.gravity = CGVectorMake(0, 0);
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    view.showsNodeCount = YES;
    view.showsPhysics = YES;
//    view.showsFields = true;

    self.physicsWorld.gravity = CGVectorMake(0, 0);

    SKFieldNode *upFlow = [SKFieldNode linearGravityFieldWithVector:simd_make_float3(0, 2, 0)];
    upFlow.categoryBitMask = 1 << 1;
    [self addChild:upFlow];

    SKFieldNode *drag = [SKFieldNode dragField];
    drag.strength = 0.2;
    [self addChild:drag];

    CGFloat y = view.frame.size.height/2 - view.frame.size.height * 0.2;
    CGFloat x = view.frame.size.width/2 - view.frame.size.height * 0.2;
    DDHTimeline *timeline = [[DDHTimeline alloc] initWithStartPoint:CGPointMake(-x, -y) andEndPoint:CGPointMake(x, -y)];
    [self addChild:timeline];

    DDHBalloon *balloon = [[DDHBalloon alloc] initWithWidth:50];
    balloon.position = CGPointMake(-100, -y);
    balloon.physicsBody.fieldBitMask = 1 << 1;
    [self addChild:balloon];

    DDHBalloon *anchor = [[DDHBalloon alloc] initWithWidth:1];
    anchor.position = CGPointMake(-100, -y);
    anchor.physicsBody.fieldBitMask = 1 << 2;
    anchor.physicsBody.dynamic = false;
    [self addChild:anchor];

    SKPhysicsJointLimit *joint = [SKPhysicsJointLimit jointWithBodyA:balloon.physicsBody bodyB:anchor.physicsBody anchorA:balloon.position anchorB:anchor.position];
    joint.maxLength = 60;
    [self.physicsWorld addJoint:joint];
}


- (void)touchDownAtPoint:(CGPoint)pos {
//    SKShapeNode *n = [_spinnyNode copy];
//    n.position = pos;
//    NSLog(@"pos: %lf %lf", pos.x, pos.y);
//    n.strokeColor = [SKColor greenColor];
//    [self addChild:n];
}

- (void)touchMovedToPoint:(CGPoint)pos {
//    SKShapeNode *n = [_spinnyNode copy];
//    n.position = pos;
//    n.strokeColor = [SKColor blueColor];
//    [self addChild:n];
}

- (void)touchUpAtPoint:(CGPoint)pos {
//    SKShapeNode *n = [_spinnyNode copy];
//    n.position = pos;
//    n.strokeColor = [SKColor redColor];
//    [self addChild:n];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    // Run 'Pulse' action from 'Actions.sks'
//    [_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
//    
//    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
