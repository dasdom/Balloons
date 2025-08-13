//  Created by Dominik Hauser on 27.10.24.
//  
//


#import "DDHTimelineScene.h"
#import "DDHBalloon.h"
#import "DDHTimeline.h"
#import "DDHDateHelper.h"
#import "DDHDisplayMonth.h"
#import "DDHBirthday.h"
#import "DDHBalloonAnchor.h"
#import <CoreMotion/CoreMotion.h>
#import "DDHRope.h"
#import "NSUserDefaults+Extension.h"

@interface DDHTimelineScene ()
@property (nonatomic, weak) id<DDHTimelineSceneProtocol> timelineDelegate;
@property (nonatomic, strong) NSArray<SKPhysicsJoint *> *balloonJoints;
@property (nonatomic, strong) NSArray<DDHBalloon *> *balloons;
@property (nonatomic, strong) NSArray<DDHBalloonAnchor *> *anchors;
@property (nonatomic, strong) NSArray<SKLabelNode *> *monthNamesNodes;
@property (nonatomic, strong) NSArray<SKShapeNode *> *lineNodes;
//@property (nonatomic, strong) NSArray<DDHRope *> *ropes;
@property (nonatomic, strong) NSArray<SKShapeNode *> *ropes;
@property (assign) CGFloat timelineYPosition;
@property (assign) CGFloat timelineStart;
@property (nonatomic, assign) NSInteger numberOfShownDays;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (assign) UIDeviceOrientation lastLandscapeOrientation;
@property (nonatomic, assign) CGFloat gravityFactor;
@property (nonatomic, strong) DDHTimeline *timeline;
@property (nonatomic, strong) DDHBalloon *detailBalloon;
@property (nonatomic, strong) DDHBalloon *selectedBalloon;
@property (assign) CGPoint positionOfSelectedBalloon;
@property (nonatomic, strong) NSPersonNameComponentsFormatter *nameFormatter;
@property (nonatomic, strong) NSDateFormatter *dateFormatterWithYear;
@property (nonatomic, strong) NSDateFormatter *dateFormatterWithoutYear;
@property (nonatomic, strong) NSArray<SKTexture *> *personWalkingFrames;
@property (nonatomic, strong) NSArray<SKTexture *> *attachingFrames;
@property (nonatomic, strong) SKSpriteNode *personNode;
@property (assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat balloonWidth;
@end

@implementation DDHTimelineScene

- (instancetype)initWithSize:(CGSize)size timelineDelegate:(id<DDHTimelineSceneProtocol>)timelineDelegate {
    if (self = [super initWithSize:size]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.gravityFactor = 7;
        self.physicsWorld.gravity = CGVectorMake(0, self.gravityFactor);
        self.motionManager = [[CMMotionManager alloc] init];

        self.timelineDelegate = timelineDelegate;

        self.scaleMode = SKSceneScaleModeResizeFill;

        _nameFormatter = [[NSPersonNameComponentsFormatter alloc] init];
        _nameFormatter.style = NSPersonNameComponentsFormatterStyleMedium;

        _dateFormatterWithYear = [[NSDateFormatter alloc] init];
        _dateFormatterWithYear.dateStyle = NSDateFormatterShortStyle;
        _dateFormatterWithYear.timeStyle = NSDateFormatterNoStyle;

        _dateFormatterWithoutYear = [[NSDateFormatter alloc] init];
        _dateFormatterWithoutYear.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MMdd" options:0 locale:[NSLocale currentLocale]];

        _numberOfShownDays = [[NSUserDefaults standardUserDefaults] numberOfShownDays];
    }
    return self;
}

- (CGFloat)balloonWidth {
    if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        return 44;
    } else {
        return 80;
    }
}

- (void)setGravityFactor:(CGFloat)gravityFactor {
    _gravityFactor = gravityFactor;
    self.physicsWorld.gravity = CGVectorMake(0, gravityFactor);
}

- (void)setNumberOfShownDays:(NSInteger)numberOfShownDays {
    _numberOfShownDays = numberOfShownDays;

    [self updateMonthNamesNodes];

//    CGFloat animationDuration = 2;
//
//    for (DDHRope *rope in self.ropes) {
//        [rope runAction:[SKAction sequence:@[
//            [SKAction fadeOutWithDuration:0.1],
//            [SKAction waitForDuration:animationDuration + 1],
//            [SKAction fadeInWithDuration:0.1]
//        ]]];
//    }
//
//    for (DDHBalloonAnchor *anchor in self.anchors) {
//        CGFloat xPos = self.timelineStart * 2 * anchor.daysLeft / numberOfShownDays - self.timelineStart;
//        SKAction *move = [SKAction moveToX:xPos duration:animationDuration];
//        move.timingMode = SKActionTimingEaseInEaseOut;
//        [anchor runAction:move];
//    }
//
//    for (SKLabelNode *label in self.monthNamesNodes) {
//        CGFloat labelX = self.timelineStart * 2 * label.name.integerValue / numberOfShownDays - self.timelineStart;
//        SKAction *move = [SKAction moveToX:labelX duration:animationDuration];
//        move.timingMode = SKActionTimingEaseInEaseOut;
//        [label runAction:move];
//    }
//
//    for (SKShapeNode *line in self.lineNodes) {
//        CGFloat startX = self.timelineStart * 2 * line.name.integerValue / numberOfShownDays - self.timelineStart;
//        SKAction *move = [SKAction moveToX:startX duration:animationDuration];
//        move.timingMode = SKActionTimingEaseInEaseOut;
//        [line runAction:move];
//    }

}

- (void)didMoveToView:(SKView *)view {
//    view.showsNodeCount = YES;
//    view.showsPhysics = YES;
//    view.showsFields = true;

    [self.motionManager startAccelerometerUpdates];

    SKFieldNode *drag = [SKFieldNode dragField];
    drag.strength = 0.2;
    [self addChild:drag];

    CGSize viewSize = view.frame.size;
    CGFloat timelineYPosition = viewSize.height/2 - viewSize.height * 0.15;
    CGFloat timelineStart = viewSize.width/2 - viewSize.width * 0.05;
    self.timelineYPosition = timelineYPosition;
    self.timelineStart = timelineStart;

    SKCameraNode *camera = [[SKCameraNode alloc] init];
    self.camera = camera;
    [self addChild:camera];

    DDHTimeline *timeline = [[DDHTimeline alloc] initWithStartPoint:CGPointMake(-timelineStart, -timelineYPosition) andEndPoint:CGPointMake(timelineStart * 10, -timelineYPosition)];
    [self addChild:timeline];
    self.timeline = timeline;

    [self updateMonthNamesNodes];

    [self loadAnimationFrames];

    SKLabelNode *titleNode = [SKLabelNode labelNodeWithText:@"Birthdays"];
    titleNode.position = CGPointMake(0, timelineYPosition);
    [self addChild:titleNode];

    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [view addGestureRecognizer:panRecognizer];

//    [self insertBirthday:[[DDHBirthday alloc] initWithUUID:[NSUUID UUID] date:[NSDate dateWithTimeIntervalSinceNow:-330 * 24 * 60 * 60] personNameComponents:[[NSPersonNameComponents alloc] init] yearUnknown:NO]];
}

- (void)loadAnimationFrames {
    SKTextureAtlas *textureAtlas = [SKTextureAtlas atlasNamed:@"WalkingImages"];
    NSMutableArray<SKTexture *> *walkFrames = [[NSMutableArray alloc] init];

    NSInteger imagesCount = [textureAtlas.textureNames count];
    for (NSInteger i=1; i<imagesCount; i++) {
        NSString *textureName = [NSString stringWithFormat:@"dom%ld", i];
        [walkFrames addObject:[textureAtlas textureNamed:textureName]];
    }
    self.personWalkingFrames = walkFrames;

    textureAtlas = [SKTextureAtlas atlasNamed:@"AttachImages"];
    NSMutableArray<SKTexture *> *attachingFrames = [[NSMutableArray alloc] init];

    imagesCount = [textureAtlas.textureNames count];
    for (NSInteger i=1; i<imagesCount; i++) {
        NSString *textureName = [NSString stringWithFormat:@"attach%ld", i];
        [attachingFrames addObject:[textureAtlas textureNamed:textureName]];
    }
    self.attachingFrames = attachingFrames;
}

- (void)animateWalk {
    [self.personNode runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.personWalkingFrames timePerFrame:0.09]]
                       withKey:@"walkingInPlace"];
}

- (void)animateAttach {
    [self.personNode runAction:[SKAction animateWithTextures:self.attachingFrames timePerFrame:0.09]
                       withKey:@"attach"];
}

- (void)insertBirthday:(DDHBirthday *)birthday {
    CGFloat xPos = self.timelineStart * 2 * birthday.daysLeft / self.numberOfShownDays - self.timelineStart;

    BOOL shouldAnimate = xPos < self.frame.size.width/2;

    CGPoint position = CGPointMake(CGRectGetMaxX(self.frame) + 20, -self.timelineYPosition + 50);
    if (shouldAnimate) {
        SKTexture *firstTexture = [self.personWalkingFrames firstObject];
        self.personNode = [[SKSpriteNode alloc] initWithTexture:firstTexture];
        self.personNode.size = CGSizeMake(50, 100);
        self.personNode.position = position;
        self.personNode.zPosition = 2;

        [self addChild:self.personNode];
        [self animateWalk];
    }

    CGFloat hue = birthday.daysLeft/366.0;
    UIColor *ropeColor = [UIColor colorWithHue:hue saturation:0.7 brightness:0.7 alpha:1];
    DDHBalloon *balloon = [[DDHBalloon alloc] initWithBirthday:birthday width:self.balloonWidth color:ropeColor];
    position = CGPointMake(xPos, position.y + 70);
    balloon.position = position;

    for (DDHBalloon *otherBalloon in self.balloons) {
        CGSize intersectionSize = CGRectIntersection(otherBalloon.frame, balloon.frame).size;
        if (intersectionSize.width > 5 || intersectionSize.height > 5) {
            NSLog(@"overlapping: %@", birthday.personNameComponents.givenName);
            position = CGPointMake(xPos, otherBalloon.position.y + self.balloonWidth + 6);
            balloon.position = position;
        }
    }

    if (shouldAnimate) {
        position = CGPointMake(self.personNode.position.x - 10, position.y + 80);
    } else {
        position = CGPointMake(xPos, position.y);
    }
    balloon.position = position;
    [self addChild:balloon];
    self.balloons = [self.balloons arrayByAddingObject:balloon];

    DDHBalloonAnchor *anchor = [DDHBalloonAnchor anchorNodeWithDaysLeft:birthday.daysLeft forBirthdayId:birthday.uuid];
    if (shouldAnimate) {
        anchor.position = CGPointMake(self.personNode.position.x - 10, self.personNode.position.y + 30);
    } else {
        anchor.position = CGPointMake(xPos, -self.timelineYPosition);
    }
    anchor.zPosition = 1;
    [self addChild:anchor];
    self.anchors = [self.anchors arrayByAddingObject:anchor];

    SKConstraint *constraint = [SKConstraint distance:[SKRange rangeWithUpperLimit:balloon.position.y - anchor.position.y] toNode:anchor];
    balloon.constraints = @[constraint];

    CGPoint balloonAnchor = CGPointMake(balloon.position.x, balloon.position.y - balloon.size.height/2);
//    DDHRope *rope = [[DDHRope alloc] initWithBirthdayId:birthday.uuid];
//    rope.zPosition = 0;
//    [self addChild:rope];
//    [rope joinToStartNode:balloon startAnchor:balloonAnchor endNode:anchor endAnchor:anchor.position inScene:self];
//    self.ropes = [self.ropes arrayByAddingObject:rope];

    SKShapeNode *rope = [SKShapeNode node];
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, balloon.position.x, balloon.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, anchor.position.x, anchor.position.y);
    rope.path = pathToDraw;
    rope.strokeColor = ropeColor;
    [self.timeline addChild:rope];
    self.ropes = [self.ropes arrayByAddingObject:rope];

    SKPhysicsJointLimit *joint = [SKPhysicsJointLimit jointWithBodyA:balloon.physicsBody bodyB:anchor.physicsBody anchorA:balloonAnchor anchorB:anchor.position];
    [self.physicsWorld addJoint:joint];
    self.balloonJoints = [self.balloonJoints arrayByAddingObject:joint];

    if (shouldAnimate) {
        CGFloat timeFactor = 5;
        CGFloat distance1 = fabs(position.x - xPos);
        CGFloat duration1 = distance1/self.frame.size.width * timeFactor;
        CGFloat distance2 = fabs(xPos - (-self.frame.size.width/2 - 30));
        CGFloat duration2 = distance2/self.frame.size.width * timeFactor;

        SKAction *moveToBirthdayAction = [SKAction moveToX:xPos duration:duration1];

        [self.personNode runAction:[SKAction sequence:@[
            moveToBirthdayAction,
            [SKAction runBlock:^{ [self.personNode removeActionForKey:@"walkingInPlace"]; }],
            [SKAction animateWithTextures:self.attachingFrames timePerFrame:0.09],
            [SKAction runBlock:^{
            [self animateWalk];
        }],
            [SKAction moveToX:-self.frame.size.width/2 - 30 duration:duration2]
        ]]
                        completion:^{
            [self.personNode removeAllActions];
            [self.personNode removeFromParent];
            self.personNode = nil;
        }];

        [anchor runAction:[SKAction sequence:@[
            moveToBirthdayAction,
            [SKAction moveToY:-self.timelineYPosition duration:0.5]
        ]]];
    }
}

- (void)updateMonthNamesNodes {
    if (self.numberOfShownDays < 1) {
        return;
    }

    for (SKNode *node in self.monthNamesNodes) {
        [node removeFromParent];
    }
    for (SKNode *node in self.lineNodes) {
        [node removeFromParent];
    }

    BOOL useVeryShort = self.numberOfShownDays > 200;
    NSArray<DDHDisplayMonth *> *displayMonths = [DDHDateHelper displayMonthsUseVeryShort:useVeryShort];

    NSMutableArray<SKLabelNode *> *monthNamesNodes = [[NSMutableArray alloc] initWithCapacity:displayMonths.count];
    NSMutableArray<SKShapeNode *> *lineNodes = [[NSMutableArray alloc] initWithCapacity:displayMonths.count];

    for (DDHDisplayMonth *displayMonth in displayMonths) {
        SKLabelNode *label = [SKLabelNode labelNodeWithText:displayMonth.name];
        CGFloat labelX = self.timelineStart * 2 * (displayMonth.start + displayMonth.end)/2 / self.numberOfShownDays - self.timelineStart;
        label.position = CGPointMake(labelX, -self.timelineYPosition - 35);
        label.name = [NSString stringWithFormat:@"%ld", (long)((displayMonth.start + displayMonth.end)/2)];
        [monthNamesNodes addObject:label];
        [self addChild:label];

        CGFloat startX = self.timelineStart * 2 * displayMonth.start / self.numberOfShownDays - self.timelineStart;
        if (startX > -self.timelineStart) {
            SKShapeNode *lineNode = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, 1, 20)];
            lineNode.name = [NSString stringWithFormat:@"%ld", (long)displayMonth.start];
            lineNode.strokeColor = [UIColor clearColor];
            lineNode.fillColor = [UIColor whiteColor];
            lineNode.position = CGPointMake(startX, -self.timelineYPosition - 20);
            lineNode.lineWidth = 1;
            [lineNodes addObject:lineNode];
            lineNode.zPosition = 0;

            [self addChild:lineNode];
        }
    }
    self.monthNamesNodes = [monthNamesNodes copy];
    self.lineNodes = [lineNodes copy];
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
    for (DDHRope *rope in self.ropes) {
        [rope removeFromParent];
//        [rope removeFromParentWithScene:self];
    }

    NSMutableArray<DDHBalloon *> *balloons = [[NSMutableArray alloc] initWithCapacity:birthdays.count];
    NSMutableArray<DDHBalloonAnchor *> *anchors = [[NSMutableArray alloc] initWithCapacity:birthdays.count];
    NSMutableArray<SKPhysicsJoint *> *joints = [[NSMutableArray alloc] initWithCapacity:birthdays.count];
//    NSMutableArray<DDHRope *> *ropes = [[NSMutableArray alloc] initWithCapacity:birthdays.count];
    NSMutableArray<SKShapeNode *> *ropes = [[NSMutableArray alloc] initWithCapacity:birthdays.count];

    for (DDHBirthday *birthday in birthdays) {
//        if (birthday.daysLeft > self.numberOfShownDays) {
//            NSLog(@"skipping: %@", birthday.personNameComponents.givenName);
//            continue;
//        } else {
            NSLog(@"adding: %@", birthday.personNameComponents.givenName);
//        }

        CGFloat xPos = self.timelineStart * 2 * birthday.daysLeft / self.numberOfShownDays - self.timelineStart;

        CGFloat hue = birthday.daysLeft/366.0;
        UIColor *ropeColor = [UIColor colorWithHue:hue saturation:0.7 brightness:0.7 alpha:1];
        DDHBalloon *balloon = [[DDHBalloon alloc] initWithBirthday:birthday width:self.balloonWidth color:ropeColor];
        CGFloat yPos = -self.timelineYPosition + self.balloonWidth + 16 + arc4random_uniform(20);
        CGPoint position = CGPointMake(xPos, yPos);
        balloon.position = position;
        [self addChild:balloon];

        for (DDHBalloon *otherBalloon in balloons) {
            CGSize intersectionSize = CGRectIntersection(otherBalloon.frame, balloon.frame).size;
            if (intersectionSize.width > 5 || intersectionSize.height > 5) {
                NSLog(@"overlapping: %@", birthday.personNameComponents.givenName);
                CGPoint position = CGPointMake(xPos, otherBalloon.position.y + self.balloonWidth + 6);
                balloon.position = position;
            }
        }

        [balloons addObject:balloon];

        DDHBalloonAnchor *anchor = [DDHBalloonAnchor anchorNodeWithDaysLeft:birthday.daysLeft forBirthdayId:birthday.uuid];
        CGPoint anchorPosition = CGPointMake(xPos, -self.timelineYPosition);
        anchor.position = anchorPosition;
        anchor.zPosition = 1;
        [self addChild:anchor];
        [anchors addObject:anchor];

        SKConstraint *constraint = [SKConstraint distance:[SKRange rangeWithUpperLimit:balloon.position.y - anchor.position.y] toNode:anchor];
        balloon.constraints = @[constraint];

        CGPoint balloonAnchor = CGPointMake(balloon.position.x, balloon.position.y - balloon.size.height/2);
//        DDHRope *rope = [[DDHRope alloc] initWithBirthdayId:birthday.uuid];
//        rope.zPosition = 0;
//        [self addChild:rope];
//        [rope joinToStartNode:balloon startAnchor:balloonAnchor endNode:anchor endAnchor:anchor.position inScene:self];
//        [ropes addObject:rope];

        SKShapeNode *rope = [SKShapeNode node];
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, balloon.position.x, balloon.position.y);
        CGPathAddLineToPoint(pathToDraw, NULL, anchor.position.x, anchor.position.y);
        rope.path = pathToDraw;
        rope.strokeColor = ropeColor;
        [self addChild:rope];
        [ropes addObject:rope];

        SKPhysicsJointLimit *joint = [SKPhysicsJointLimit jointWithBodyA:balloon.physicsBody bodyB:anchor.physicsBody anchorA:balloonAnchor anchorB:anchor.position];
        [self.physicsWorld addJoint:joint];
        [joints addObject:joint];
    }

    self.balloons = [balloons copy];
    self.anchors = [anchors copy];
    self.balloonJoints = [joints copy];
    self.ropes = [ropes copy];
}

- (void)touchUpAtPoint:(CGPoint)pos {
    SKNode *node = [self nodeAtPoint:pos];
    if ([node isKindOfClass:[DDHBalloon class]] &&
        nil == self.detailBalloon) {

        DDHBalloon *balloon = (DDHBalloon *)node;
        [self showBalloon:balloon];

        [self.timelineDelegate didSelectBalloonInScene:self];

    } else if (self.detailBalloon) {
        if ([node.name isEqual:@"delete"]) {
            self.gravityFactor = 7;
            [self.timelineDelegate scene:self didSelectDeleteForBirthdayWithUUID:self.detailBalloon.birthdayId];

            self.detailBalloon.physicsBody.affectedByGravity = YES;
            [self removeNodesForBirthdayId:self.detailBalloon.birthdayId];

            [self runAction:[SKAction waitForDuration:2] completion:^{
                [self.detailBalloon removeFromParent];
                self.detailBalloon = nil;
                [self hideDetailBalloon];
            }];
        } else if ([node.name isEqual:@"presents"]) {
            [self.timelineDelegate scene:self didSelectPresentsForBirthdayWithUUID:self.detailBalloon.birthdayId];
        } else {
            [self hideDetailBalloon];

            [self.timelineDelegate didSelectBalloonInScene:self];
        }
    }
}

- (void)removeNodesForBirthdayId:(NSUUID *)birthdayId {
    [self.selectedBalloon removeFromParent];

//    for (DDHRope *rope in self.ropes) {
//        if ([rope.birthdayId isEqual:birthdayId]) {
//            [rope removeFromParentWithScene:self];
//            break;
//        }
//    }

    NSInteger index = [self.anchors indexOfObjectPassingTest:^BOOL(DDHBalloonAnchor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.birthdayId isEqual:birthdayId];
    }];

    DDHBalloonAnchor *anchor = self.anchors[index];
    [anchor removeFromParent];

    SKShapeNode *rope = self.ropes[index];
    [rope removeFromParent];
}

- (void)showBalloon:(DDHBalloon *)balloon {
    self.selectedBalloon = balloon;
    self.positionOfSelectedBalloon = balloon.position;
    balloon.hidden = YES;

    DDHBalloon *detailBalloon = [balloon balloonCopyForDetail];
    [self addChild:detailBalloon];
    self.detailBalloon = detailBalloon;

    SKAction *animation = [SKAction group:@[
        [SKAction resizeToWidth:200 height:200 duration:1],
        [SKAction moveTo:CGPointMake(0, 70) duration:0.5],
    ]];
    animation.timingMode = SKActionTimingEaseInEaseOut;
    [detailBalloon runAction:animation completion:^{
        detailBalloon.deleteButtonNode.hidden = NO;
        [detailBalloon showInfoWithNameFormatter:self.nameFormatter dateFormatterWithYear:self.dateFormatterWithYear dateFormatterWithoutYear:self.dateFormatterWithoutYear];
    }];

    [self fadeOutMonthIndicators];

    self.gravityFactor = -7;
}

- (void)hideDetailBalloon {
    SKAction *fadeOutDetailAnimation = [SKAction group:@[
//        [SKAction resizeToWidth:50 height:50 duration:0.3],
//        [SKAction moveTo:self.positionOfSelectedBalloon duration:0.5],
        [SKAction fadeOutWithDuration:0.3],
    ]];
    fadeOutDetailAnimation.timingMode = SKActionTimingEaseInEaseOut;

//    self.detailBalloon.physicsBody.affectedByGravity = YES;

    SKAction *fadeInSelectedAnimation = [SKAction sequence:@[
        [SKAction waitForDuration:0.3],
        [SKAction fadeInWithDuration:0.3]
    ]];
    fadeInSelectedAnimation.timingMode = SKActionTimingEaseInEaseOut;

    self.detailBalloon.deleteButtonNode.hidden = YES;
    [self.detailBalloon showLabel:false animated:true];

    self.selectedBalloon.alpha = 0;
    self.selectedBalloon.hidden = NO;

    [self.detailBalloon runAction:fadeOutDetailAnimation completion:^{
        [self.detailBalloon removeFromParent];
        self.detailBalloon = nil;

        [self fadeInMonthIndicators];
        self.gravityFactor = 7;
    }];

    [self.selectedBalloon runAction:fadeInSelectedAnimation completion:^{
        self.selectedBalloon = nil;
    }];
}

- (void)fadeOutMonthIndicators {
    for (SKLabelNode *monthNameNode in self.monthNamesNodes) {
        [monthNameNode runAction:[SKAction fadeOutWithDuration:0.5]];
    }
    for (SKShapeNode *lineNodes in self.lineNodes) {
        [lineNodes runAction:[SKAction fadeOutWithDuration:0.5]];
    }
}

- (void)fadeInMonthIndicators {
    for (SKLabelNode *monthNameNode in self.monthNamesNodes) {
        [monthNameNode runAction:[SKAction fadeInWithDuration:0.5]];
    }
    for (SKLabelNode *lineNode in self.lineNodes) {
        [lineNode runAction:[SKAction fadeInWithDuration:0.5]];
    }
}

- (void)pan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.panStartPoint = self.camera.position;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        SKAction *moveAction = [SKAction moveToX:self.panStartPoint.x duration:0.3];
        [self.camera runAction:moveAction];
    } else {
        CGPoint translation = [sender translationInView:self.view];

        CGPoint position = self.camera.position;
        position.x = (self.panStartPoint.x - translation.x);
        self.camera.position = position;
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [event.allTouches anyObject];
//    self.panStartPoint = [touch locationInNode:self];
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [event.allTouches anyObject];
//    CGPoint currentLocation = [touch locationInNode:self];
//
////    CGPoint position = self.timeline.position;
////    position.x = (currentLocation.x - self.panStartPoint.x);
////    self.timeline.position = position;
//
//    CGPoint position = self.camera.position;
//    position.x = (self.panStartPoint.x - currentLocation.x);
//    NSLog(@"panStartPoint: %ld", (long)self.panStartPoint.x);
//    NSLog(@"currentLocation: %ld", (long)currentLocation.x);
//    NSLog(@"x: %ld", (long)position.x);
//    self.camera.position = position;
//}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        [self touchUpAtPoint:[t locationInNode:self]];
    }
}

- (void)update:(CFTimeInterval)currentTime {
    CMAccelerometerData *accelerometerData = self.motionManager.accelerometerData;
    if (accelerometerData) {
        [self updateGravityWithOrientation:UIDevice.currentDevice.orientation accelerometerData:accelerometerData];
    }
}

- (void)updateGravityWithOrientation:(UIDeviceOrientation)orientation accelerometerData:(CMAccelerometerData *)accelerometerData {
    if (orientation == UIDeviceOrientationLandscapeLeft) {
        self.lastLandscapeOrientation = orientation;
        self.physicsWorld.gravity = CGVectorMake(accelerometerData.acceleration.y * self.gravityFactor,
                                                 -accelerometerData.acceleration.x * self.gravityFactor);
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
        self.lastLandscapeOrientation = orientation;
        self.physicsWorld.gravity = CGVectorMake(-accelerometerData.acceleration.y * self.gravityFactor,
                                                 accelerometerData.acceleration.x * self.gravityFactor);
    } else if (orientation == UIDeviceOrientationPortrait) {
        self.lastLandscapeOrientation = orientation;
        self.physicsWorld.gravity = CGVectorMake(-accelerometerData.acceleration.x * self.gravityFactor,
                                                 -accelerometerData.acceleration.y * self.gravityFactor);
    } else {
        self.physicsWorld.gravity = CGVectorMake(0, self.gravityFactor);
    }
}

- (void)updateWithSize:(CGSize)size {
    self.size = size;
}

- (void)didChangeSize:(CGSize)oldSize {
    CGSize size = self.size;
    CGFloat timelineYPosition = size.height/2 - size.height * 0.15;
    CGFloat timelineStart = size.width/2 - size.width * 0.05;
    self.timelineYPosition = timelineYPosition;
    self.timelineStart = timelineStart;

    CGPoint startPoint = CGPointMake(-timelineStart, -timelineYPosition);
    CGPoint endPoint = CGPointMake(timelineStart * 1.5, -timelineYPosition);
    [self.timeline updateWithStartPoint:startPoint andEndPoint:endPoint];

    [self updateMonthNamesNodes];
}

- (void)didSimulatePhysics {
    for (NSInteger i=0; i<[self.balloons count]; i++) {
        DDHBalloon *balloon = self.balloons[i];
        DDHBalloonAnchor *anchor = self.anchors[i];

        SKShapeNode *rope = self.ropes[i];

        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, balloon.position.x, balloon.position.y);
        CGPathAddLineToPoint(pathToDraw, NULL, anchor.position.x, anchor.position.y);
        rope.path = pathToDraw;
    }
}

- (void)toggleGravityDirection {
    self.gravityFactor = -self.gravityFactor;
    if (self.gravityFactor < 0) {
        [self fadeOutMonthIndicators];
    } else {
        [self fadeInMonthIndicators];
    }
}

- (void)pointGravityDown {
    self.gravityFactor = -fabs(self.gravityFactor);
//    [self fadeOutMonthIndicators];
}

- (void)pointGravityUp {
    self.gravityFactor = fabs(self.gravityFactor);
//    [self fadeInMonthIndicators];
}

@end
