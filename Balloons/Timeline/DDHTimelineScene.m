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
@property (nonatomic, strong) NSArray<SKPhysicsJoint *> *balloonJoints;
@property (nonatomic, strong) NSArray<DDHBalloon *> *balloons;
@property (nonatomic, strong) NSArray<DDHBalloonAnchor *> *anchors;
@property (nonatomic, strong) NSArray<SKLabelNode *> *monthNamesNodes;
@property (nonatomic, strong) NSArray<SKShapeNode *> *lineNodes;
@property (nonatomic, strong) NSArray<DDHRope *> *ropes;
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
@end

@implementation DDHTimelineScene

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.gravityFactor = 7;
        self.physicsWorld.gravity = CGVectorMake(0, self.gravityFactor);
        self.motionManager = [[CMMotionManager alloc] init];

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

- (void)setGravityFactor:(CGFloat)gravityFactor {
    _gravityFactor = gravityFactor;
    self.physicsWorld.gravity = CGVectorMake(0, gravityFactor);
}

- (void)setNumberOfShownDays:(NSInteger)numberOfShownDays {
    _numberOfShownDays = numberOfShownDays;

//    [self updateMonthNamesNodes];

    for (DDHBalloonAnchor *anchor in self.anchors) {
        CGFloat xPos = self.timelineStart * 2 * anchor.daysLeft / self.numberOfShownDays - self.timelineStart;
        SKAction *move = [SKAction moveToX:xPos duration:1];
        move.timingMode = SKActionTimingEaseInEaseOut;
        [anchor runAction:move];
    }

    for (SKLabelNode *label in self.monthNamesNodes) {
        CGFloat labelX = self.timelineStart * 2 * label.name.integerValue / numberOfShownDays - self.timelineStart;
        SKAction *move = [SKAction moveToX:labelX duration:1];
        move.timingMode = SKActionTimingEaseInEaseOut;
        [label runAction:move];
    }

    for (SKShapeNode *line in self.lineNodes) {
        CGFloat startX = self.timelineStart * 2 * line.name.integerValue / self.numberOfShownDays - self.timelineStart;
        SKAction *move = [SKAction moveToX:startX duration:1];
        move.timingMode = SKActionTimingEaseInEaseOut;
        [line runAction:move];
    }
}

- (void)didMoveToView:(SKView *)view {
    view.showsNodeCount = YES;
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

    DDHTimeline *timeline = [[DDHTimeline alloc] initWithStartPoint:CGPointMake(-timelineStart, -timelineYPosition) andEndPoint:CGPointMake(timelineStart * 1.5, -timelineYPosition)];
    [self addChild:timeline];
    self.timeline = timeline;

    [self updateMonthNamesNodes];
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

    BOOL useVeryShort = self.size.width < self.size.height;
    NSArray<DDHDisplayMonth *> *displayMonths = [DDHDateHelper displayMonthsUseVeryShort:useVeryShort];

    NSMutableArray<SKLabelNode *> *monthNamesNodes = [[NSMutableArray alloc] initWithCapacity:displayMonths.count];
    NSMutableArray<SKShapeNode *> *lineNodes = [[NSMutableArray alloc] initWithCapacity:displayMonths.count];

    for (DDHDisplayMonth *displayMonth in displayMonths) {
        SKLabelNode *label = [SKLabelNode labelNodeWithText:displayMonth.name];
        CGFloat labelX = self.timelineStart * 2 * (displayMonth.start + displayMonth.end)/2 / self.numberOfShownDays - self.timelineStart;
        label.position = CGPointMake(labelX, -self.timelineYPosition - 30);
        label.name = [NSString stringWithFormat:@"%ld", (long)((displayMonth.start + displayMonth.end)/2)];
        [monthNamesNodes addObject:label];
        [self addChild:label];

        CGFloat startX = self.timelineStart * 2 * displayMonth.start / self.numberOfShownDays - self.timelineStart;
        if (startX > -self.timelineStart) {
//            UIBezierPath *path = [[UIBezierPath alloc] init];
//            CGPoint start = CGPointMake(startX, -self.timelineYPosition - 30);
//            [path moveToPoint:start];
//            CGPoint end = CGPointMake(startX, 2 * self.timelineYPosition);
//            [path addLineToPoint:end];

            SKShapeNode *lineNode = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, 1, 3 * self.timelineYPosition)];
            lineNode.name = [NSString stringWithFormat:@"%ld", (long)displayMonth.start];
            lineNode.strokeColor = [UIColor clearColor];
            lineNode.fillColor = [UIColor colorWithWhite:0.3 alpha:1];
            lineNode.position = CGPointMake(startX, -self.timelineYPosition - 30);
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
        [rope removeFromParentWithScene:self];
    }

    NSMutableArray<DDHBalloon *> *balloons = [[NSMutableArray alloc] initWithCapacity:birthdays.count];
    NSMutableArray<DDHBalloonAnchor *> *anchors = [[NSMutableArray alloc] initWithCapacity:birthdays.count];
    NSMutableArray<SKPhysicsJoint *> *joints = [[NSMutableArray alloc] initWithCapacity:birthdays.count];
    NSMutableArray<DDHRope *> *ropes = [[NSMutableArray alloc] initWithCapacity:birthdays.count];

    for (DDHBirthday *birthday in birthdays) {
        CGFloat xPos = self.timelineStart * 2 * birthday.daysLeft / self.numberOfShownDays - self.timelineStart;

        DDHBalloon *balloon = [[DDHBalloon alloc] initWithBirthday:birthday width:50];
        CGFloat yPos = -self.timelineYPosition + 60 + arc4random_uniform(20);
        CGPoint position = CGPointMake(xPos, yPos);
        balloon.position = position;
        [self addChild:balloon];

        for (DDHBalloon *otherBalloon in balloons) {
            CGSize intersectionSize = CGRectIntersection(otherBalloon.frame, balloon.frame).size;
            if (intersectionSize.width > 1 || intersectionSize.height > 1) {
                NSLog(@"overlapping: %@", birthday.personNameComponents.givenName);
                CGFloat correctedYPos = otherBalloon.position.y + otherBalloon.size.height + arc4random_uniform(40);
                if (correctedYPos > 2 * (self.timelineYPosition - 20)) {
                    correctedYPos = -self.timelineYPosition + 60 + arc4random_uniform(40);
                }
                CGPoint position = CGPointMake(xPos, otherBalloon.position.y + 60);
                balloon.position = position;
            }
        }

        [balloons addObject:balloon];

        DDHBalloonAnchor *anchor = [DDHBalloonAnchor anchorNodeWithDaysLeft:birthday.daysLeft];
        CGPoint anchorPosition = CGPointMake(xPos, -self.timelineYPosition);
        anchor.position = anchorPosition;
        anchor.zPosition = 1;
        [self addChild:anchor];
        [anchors addObject:anchor];

        SKConstraint *constraint = [SKConstraint distance:[SKRange rangeWithUpperLimit:balloon.position.y - anchor.position.y] toNode:anchor];
        balloon.constraints = @[constraint];

        CGPoint balloonAnchor = CGPointMake(balloon.position.x, balloon.position.y - balloon.size.height/2);
        DDHRope *rope = [[DDHRope alloc] init];
        rope.zPosition = 0;
        [self addChild:rope];
        [rope joinToStartNode:balloon startAnchor:balloonAnchor endNode:anchor endAnchor:anchor.position inScene:self];
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
    SKNode *node = [self nodeAtPoint:pos];
    if ([node isKindOfClass:[DDHBalloon class]] &&
        nil == self.detailBalloon) {

        DDHBalloon *balloon = (DDHBalloon *)node;
        [self showBalloon:balloon];

    } else if (self.detailBalloon) {

        [self hideDetailBalloon];
    }
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
        [detailBalloon showInfoWithNameFormatter:self.nameFormatter dateFormatterWithYear:self.dateFormatterWithYear dateFormatterWithoutYear:self.dateFormatterWithoutYear];
    }];

    [self fadeOutMonthIndicators];

    self.gravityFactor = -7;
}

- (void)hideDetailBalloon {
    SKAction *animation = [SKAction group:@[
        [SKAction resizeToWidth:50 height:50 duration:0.8],
        [SKAction moveTo:self.positionOfSelectedBalloon duration:0.5],
//        [SKAction fadeOutWithDuration:0.5],
    ]];
    animation.timingMode = SKActionTimingEaseInEaseOut;

//    self.detailBalloon.physicsBody.affectedByGravity = YES;

    [self.detailBalloon showLabel:false animated:true];

    [self.detailBalloon runAction:animation completion:^{
        self.selectedBalloon.hidden = NO;
        [self.detailBalloon removeFromParent];
        self.detailBalloon = nil;
        self.selectedBalloon = nil;
    }];

    [self fadeInMonthIndicators];

    self.gravityFactor = 7;
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
    for (UITouch *t in touches) {
        [self touchUpAtPoint:[t locationInNode:self]];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
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

//- (void)didSimulatePhysics {
//    for (DDHRope *rope in self.ropes) {
//        [rope adjustRingPositions];
//    }
//}

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
