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
#import "UIImage+Extenstion.h"

@interface GameScene ()
@property (nonatomic, strong) NSArray<SKPhysicsJoint *> *balloonJoints;
@property (nonatomic, strong) NSArray<DDHBalloon *> *balloons;
@property (nonatomic, strong) NSArray<DDHBalloonAnchor *> *anchors;
@property (assign) CGFloat timelineYPosition;
@property (assign) CGFloat timelineStart;
@property (assign) NSInteger numberOfShownDays;
@end

@implementation GameScene

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

    SKFieldNode *upFlow = [SKFieldNode linearGravityFieldWithVector:simd_make_float3(0, 6, 0)];
    upFlow.categoryBitMask = 1 << 1;
    [self addChild:upFlow];

    SKFieldNode *drag = [SKFieldNode dragField];
    drag.strength = 0.2;
    [self addChild:drag];

    CGSize viewSize = view.frame.size;
    NSInteger numberOfShownDays = 100;
    self.numberOfShownDays = numberOfShownDays;

    CGFloat timelineYPosition = viewSize.height/2 - viewSize.height * 0.2;
    CGFloat timelineStart = viewSize.width/2 - viewSize.height * 0.2;
    self.timelineYPosition = timelineYPosition;
    self.timelineStart = timelineStart;

    DDHTimeline *timeline = [[DDHTimeline alloc] initWithStartPoint:CGPointMake(-timelineStart, -timelineYPosition) andEndPoint:CGPointMake(timelineStart, -timelineYPosition)];
    [self addChild:timeline];

    NSArray<DDHDisplayMonth *> *displayMonths = [DDHDateHelper displayMonths];
    for (DDHDisplayMonth *displayMonth in displayMonths) {
        SKLabelNode *label = [SKLabelNode labelNodeWithText:displayMonth.name];
        CGFloat lableX = timelineStart * 2 * (displayMonth.start + displayMonth.end)/2 / numberOfShownDays - timelineStart;
        label.position = CGPointMake(lableX, -timelineYPosition - 30);
        [self addChild:label];
    }

//    DDHBalloon *balloon = [[DDHBalloon alloc] initWithWidth:50];
//    balloon.position = CGPointMake(-100, -timelineYPosition);
//    [self addChild:balloon];
//
//    DDHBalloonAnchor *anchor = [DDHBalloonAnchor anchorNode];
//    anchor.position = CGPointMake(-100, -timelineYPosition);
//    [self addChild:anchor];
//
//    SKPhysicsJointLimit *joint = [SKPhysicsJointLimit jointWithBodyA:balloon.physicsBody bodyB:anchor.physicsBody anchorA:balloon.position anchorB:anchor.position];
//    joint.maxLength = 50;
//    [self.physicsWorld addJoint:joint];
}

//- (void)add:(UIButton *)sender {
//    DDHContactsManager *contactsManager = [[DDHContactsManager alloc] init];
//    [contactsManager requestContactsAccess:^(BOOL granted) {
//        if (granted) {
//            [contactsManager fetchImportableContactsIgnoringExitingIds:@[] completionHandler:^(NSArray<CNContact *> * _Nonnull contacts) {
//                NSArray<DDHBirthday *> *birthdays = [contactsManager birthdaysFromContacts:contacts];
//                self.birthdays = [self.birthdays arrayByAddingObjectsFromArray:birthdays];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self updateForBirthdays:self.birthdays];
//                });
//            }];
//        }
//    }];
//}

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

        DDHBalloon *balloon = [[DDHBalloon alloc] initWithWidth:50];
        CGPoint position = CGPointMake(xPos, -self.timelineYPosition);
        balloon.position = position;
        [self addChild:balloon];
        [balloons addObject:balloon];

        if (birthday.imageData) {
            UIImage *image = [UIImage imageWithData:birthday.imageData];
            UIImage *roundedImage = [image roundedWithColor:[UIColor whiteColor] width:1 targetSize:CGSizeMake(500, 500)];
            SKTexture *texture = [SKTexture textureWithImage:roundedImage];
            SKSpriteNode *imageNode = [SKSpriteNode spriteNodeWithTexture:texture];
            //        imageNode.zRotation = -45 * M_PI / 180;
            imageNode.anchorPoint = CGPointMake(0, 0);
            imageNode.size = CGSizeMake(50, 50);
            imageNode.position = CGPointMake(0, 0);
            [balloon addChild:imageNode];
        }

        DDHBalloonAnchor *anchor = [DDHBalloonAnchor anchorNode];
        anchor.position = position;
        [self addChild:anchor];
        [anchors addObject:anchor];

        SKPhysicsJointLimit *joint = [SKPhysicsJointLimit jointWithBodyA:balloon.physicsBody bodyB:anchor.physicsBody anchorA:balloon.position anchorB:anchor.position];
        joint.maxLength = arc4random_uniform(200) + 20;
        [self.physicsWorld addJoint:joint];
        [joints addObject:joint];
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


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
