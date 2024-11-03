//  Created by Dominik Hauser on 27.10.24.
//  
//


#import "GameScene.h"
#import "DDHBalloon.h"
#import "DDHTimeline.h"
#import "DDHDateHelper.h"
#import "DDHDisplayMonth.h"
#import "DDHBirthday.h"
#import "DDHBalloonAnchor.h"
//#import "UIImage+Extenstion.h"
#import <CoreMotion/CoreMotion.h>
#import "DDHRope.h"

@interface GameScene ()
@property (nonatomic, strong) NSArray<SKPhysicsJoint *> *balloonJoints;
@property (nonatomic, strong) NSArray<DDHBalloon *> *balloons;
@property (nonatomic, strong) NSArray<DDHBalloonAnchor *> *anchors;
@property (assign) CGFloat timelineYPosition;
@property (assign) CGFloat timelineStart;
@property (assign) NSInteger numberOfShownDays;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (assign) UIDeviceOrientation lastLandscapeOrientation;
@property (assign) CGFloat gravityFactor;
@end

@implementation GameScene

- (instancetype)init {
    if (self = [super initWithSize:CGSizeMake(750, 1334)]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.gravityFactor = 7;
        self.physicsWorld.gravity = CGVectorMake(0, self.gravityFactor);
        self.motionManager = [[CMMotionManager alloc] init];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    view.showsNodeCount = YES;
//    view.showsPhysics = YES;
//    view.showsFields = true;

//    SKFieldNode *upFlow = [SKFieldNode linearGravityFieldWithVector:simd_make_float3(0, 6, 0)];
//    upFlow.categoryBitMask = 1 << 1;
//    [self addChild:upFlow];

    [self.motionManager startAccelerometerUpdates];

    SKFieldNode *drag = [SKFieldNode dragField];
    drag.strength = 0.2;
    [self addChild:drag];

    CGSize viewSize = view.frame.size;
    NSInteger numberOfShownDays = 280;
    self.numberOfShownDays = numberOfShownDays;

    CGFloat timelineYPosition = viewSize.height/2 - viewSize.height * 0.2;
    CGFloat timelineStart = viewSize.width/2 - viewSize.height * 0.2;
    self.timelineYPosition = timelineYPosition;
    self.timelineStart = timelineStart;

    DDHTimeline *timeline = [[DDHTimeline alloc] initWithStartPoint:CGPointMake(-timelineStart, -timelineYPosition) andEndPoint:CGPointMake(timelineStart * 1.5, -timelineYPosition)];
    [self addChild:timeline];

    NSArray<DDHDisplayMonth *> *displayMonths = [DDHDateHelper displayMonths];
    for (DDHDisplayMonth *displayMonth in displayMonths) {
        SKLabelNode *label = [SKLabelNode labelNodeWithText:displayMonth.name];
        CGFloat lableX = timelineStart * 2 * (displayMonth.start + displayMonth.end)/2 / numberOfShownDays - timelineStart;
        label.position = CGPointMake(lableX, -timelineYPosition - 30);
        [self addChild:label];
    }
}

- (void)updateForBirthdays:(NSArray<DDHBirthday *> *)birthdays {
    for (SKPhysicsJoint *joint in self.balloonJoints) {
        [self.physicsWorld removeJoint:joint];
    }
    for (DDHBalloon *balloon in self.balloons) {
        [balloon removeFromParent];
    }
    for (DDHBalloonAnchor *anchor in self.anchors) {
        [anchor removeFromParent];
    }

    NSMutableArray<DDHBalloon *> *balloons = [[NSMutableArray alloc] initWithCapacity:birthdays.count];
    NSMutableArray<DDHBalloonAnchor *> *anchors = [[NSMutableArray alloc] initWithCapacity:birthdays.count];
    NSMutableArray<SKPhysicsJoint *> *joints = [[NSMutableArray alloc] initWithCapacity:birthdays.count];

    for (DDHBirthday *birthday in birthdays) {
        CGFloat xPos = self.timelineStart * 2 * birthday.daysLeft / self.numberOfShownDays - self.timelineStart;

        DDHBalloon *balloon = [[DDHBalloon alloc] initWithImage:birthday.imageData width:50];
        CGFloat yPos = -self.timelineYPosition + 60 + arc4random_uniform(20); //arc4random_uniform(2 * (self.timelineYPosition - 40)) + 40;
        CGPoint position = CGPointMake(xPos, yPos);
        balloon.position = position;
        balloon.zPosition = 2;
        [self addChild:balloon];

        for (DDHBalloon *otherBalloon in balloons) {
            CGSize intersectionSize = CGRectIntersection(otherBalloon.frame, balloon.frame).size;
            if (intersectionSize.width > 1 || intersectionSize.height > 1) {
                NSLog(@"overlapping: %@", birthday.personNameComponents.givenName);
                CGFloat correctedYPos = otherBalloon.position.y + 60 + arc4random_uniform(40);
                if (correctedYPos > 2 * (self.timelineYPosition - 20)) {
                    correctedYPos = -self.timelineYPosition + 60 + arc4random_uniform(40);
                }
                CGPoint position = CGPointMake(xPos, otherBalloon.position.y + 60);
                balloon.position = position;
            }
        }

        [balloons addObject:balloon];
        NSLog(@"add balloon for %@", birthday);

        SKLabelNode *nameLabel = [SKLabelNode labelNodeWithText:birthday.personNameComponents.givenName];
        nameLabel.fontSize = 13;
        nameLabel.fontName = [UIFont systemFontOfSize:13 weight:UIFontWeightHeavy].fontName;
        nameLabel.position = CGPointMake(0, -nameLabel.frame.size.height/2);
        nameLabel.fontColor = [UIColor blackColor];

        SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(nameLabel.frame.size.width, nameLabel.frame.size.height)];
        background.position = CGPointMake(0, -balloon.size.height/2);
        [background addChild:nameLabel];

        [balloon addChild:background];

        DDHBalloonAnchor *anchor = [DDHBalloonAnchor anchorNode];
        CGPoint anchorPosition = CGPointMake(xPos, -self.timelineYPosition);
        anchor.position = anchorPosition;
        anchor.zPosition = 1;
        [self addChild:anchor];
        [anchors addObject:anchor];
        NSLog(@"add anchor for %@", birthday);

        CGPoint balloonAnchor = CGPointMake(balloon.position.x, balloon.position.y - 20);
//        SKPhysicsJointLimit *joint = [SKPhysicsJointLimit jointWithBodyA:balloon.physicsBody bodyB:anchor.physicsBody anchorA:ballAnchor anchorB:anchor.position];
//        joint.maxLength = arc4random_uniform(2 * (self.timelineYPosition - 20)) + 20;
//        [self.physicsWorld addJoint:joint];
//        [joints addObject:joint];
//        NSLog(@"add joint for %@", birthday);
        DDHRope *rope = [[DDHRope alloc] init];
        rope.zPosition = 0;
        [self addChild:rope];
        [rope joinToStartNode:balloon startAnchor:balloonAnchor endNode:anchor endAnchor:anchor.position inScene:self];
    }

    self.balloons = [balloons copy];
    self.anchors = [anchors copy];
    self.balloonJoints = [joints copy];
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


- (void)update:(CFTimeInterval)currentTime {
    CMAccelerometerData *accelerometerData = self.motionManager.accelerometerData;
    if (accelerometerData) {
        if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice.orientation)) {
            [self updateGravityWithOrientation:UIDevice.currentDevice.orientation accelerometerData:accelerometerData];
        } else {
            [self updateGravityWithOrientation:self.lastLandscapeOrientation accelerometerData:accelerometerData];
        }
    }
}

- (void)updateGravityWithOrientation:(UIDeviceOrientation)orientation accelerometerData:(CMAccelerometerData *)accelerometerData {
    if (orientation == UIDeviceOrientationLandscapeLeft) {
        self.lastLandscapeOrientation = orientation;
        self.physicsWorld.gravity = CGVectorMake(accelerometerData.acceleration.y * self.gravityFactor, -accelerometerData.acceleration.x * self.gravityFactor);
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
        self.lastLandscapeOrientation = orientation;
        self.physicsWorld.gravity = CGVectorMake(-accelerometerData.acceleration.y * self.gravityFactor, accelerometerData.acceleration.x * self.gravityFactor);
    } else {
        self.physicsWorld.gravity = CGVectorMake(0, self.gravityFactor);
    }
}

@end
