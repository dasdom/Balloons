//  Created by Dominik Hauser on 01.01.25.
//  
//


#import "DDHCaveScene.h"
#import "DDHBalloon.h"
#import "DDHBirthday.h"

@interface DDHCaveScene () <SKPhysicsContactDelegate>
@property (nonatomic, strong) DDHBalloon *balloon;
@property (nonatomic, strong) SKShapeNode *pathTop;
@property (nonatomic, strong) SKShapeNode *pathBottom;
@property (nonatomic, strong) SKShapeNode *pathBackTop;
@property (nonatomic, strong) SKShapeNode *pathBackBottom;
@property (nonatomic, strong) SKEmitterNode *popEmitter;
@end

@implementation DDHCaveScene

- (void)didMoveToView:(SKView *)view {

    uint32_t wallCategory = 1 << 1;
    uint32_t balloonCategory = 1 << 2;

    NSPersonNameComponents *nameComponents = [[NSPersonNameComponents alloc] init];
    nameComponents.givenName = @"Dom";
    DDHBirthday *birthday = [[DDHBirthday alloc] initWithUUID:[NSUUID UUID] date:[NSDate date] personNameComponents:nameComponents yearUnknown:NO favorite:NO];
    UIImage *domImage = [UIImage imageNamed:@"dom"];
    birthday.imageData = UIImageJPEGRepresentation(domImage, 0.8);
    _balloon = [[DDHBalloon alloc] initWithBirthday:birthday width:20 color:[UIColor whiteColor]];
    [_balloon showLabel:NO animated:NO];
    _balloon.physicsBody.affectedByGravity = NO;
    _balloon.physicsBody.categoryBitMask = balloonCategory;
    _balloon.physicsBody.contactTestBitMask = wallCategory;
    _balloon.physicsBody.collisionBitMask = wallCategory;

    [self addChild:_balloon];

    self.physicsWorld.contactDelegate = self;
    self.backgroundColor = [UIColor systemGray2Color];

    CGPoint topPoints[1000];
    CGPoint bottomPoints[1000];

    CGPoint backTopPoints[500];
    CGPoint backBottomPoints[500];

    CGFloat x = -self.size.width/2.0;
    topPoints[0] = CGPointMake(x, self.size.height/2.0+20);
    bottomPoints[0] = CGPointMake(x, -self.size.height/2.0);

    CGFloat previousYTop = 0;
    CGFloat previousYBottom = 0;

    for (NSUInteger i=1; i<998; i++) {
        x += (CGFloat)arc4random_uniform(30)+10;

        CGFloat yTopStep = (CGFloat)arc4random_uniform(60)-30;
        CGFloat yTop = MIN(MAX(previousYTop + yTopStep, 10), 95);
        topPoints[i] = CGPointMake(x, yTop);
        previousYTop = yTop;

        CGFloat yBottomStep = (CGFloat)arc4random_uniform(60)-30;
        CGFloat space = (CGFloat)arc4random_uniform(60)+55;
        CGFloat yBottom = MAX(MIN(MAX(previousYBottom + yBottomStep, -10), yTop - space), -95);
        bottomPoints[i] = CGPointMake(x, yBottom);
        previousYBottom = yBottom;
    }

    topPoints[998] = CGPointMake(x, self.size.height/2.0+20);
    bottomPoints[998] = CGPointMake(x, -self.size.height/2.0-20);

    x = -self.size.width/2.0;
    topPoints[999] = CGPointMake(x, self.size.height/2.0+20);
    bottomPoints[999] = CGPointMake(x, -self.size.height/2.0-20);

    x -= self.size.width;
    backTopPoints[0] = CGPointMake(x, self.size.height/2.0+20);
    backBottomPoints[0] = CGPointMake(x, -self.size.height/2.0);

    for (NSUInteger i=1; i<498; i++) {
        x += (CGFloat)arc4random_uniform(10)+5;

        CGFloat yTopStep = (CGFloat)arc4random_uniform(40)-20;
        CGFloat yTop = MIN(MAX(previousYTop + yTopStep, 10), 50);
        backTopPoints[i] = CGPointMake(x, yTop);
        previousYTop = yTop;

        CGFloat yBottomStep = (CGFloat)arc4random_uniform(40)-20;
        CGFloat space = (CGFloat)arc4random_uniform(40)+20;
        CGFloat yBottom = MAX(MIN(MAX(previousYBottom + yBottomStep, -10), yTop - space), -50);
        backBottomPoints[i] = CGPointMake(x, yBottom);
        previousYBottom = yBottom;
    }

    backTopPoints[498] = CGPointMake(x, self.size.height/2.0+20);
    backBottomPoints[498] = CGPointMake(x, -self.size.height/2.0-20);

    x = -self.size.width;
    backTopPoints[499] = CGPointMake(x, self.size.height/2.0+20);
    backBottomPoints[499] = CGPointMake(x, -self.size.height/2.0-20);

    UIColor *rockBackgroundColor = [UIColor systemGray3Color];

    _pathBackTop = [SKShapeNode shapeNodeWithPoints:backTopPoints count:500];
    _pathBackTop.lineWidth = 5;
    _pathBackTop.strokeColor = rockBackgroundColor;
    _pathBackTop.fillColor = rockBackgroundColor;
//    _pathBackTop.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:_pathBackTop.path];
//    _pathBackTop.physicsBody.affectedByGravity = NO;
//    _pathBackTop.physicsBody.categoryBitMask = wallCategory;
//    _pathBackTop.physicsBody.contactTestBitMask = balloonCategory;
//    _pathBackTop.physicsBody.collisionBitMask = balloonCategory;

    [self addChild:_pathBackTop];

    _pathBackBottom = [SKShapeNode shapeNodeWithPoints:backBottomPoints count:500];
    _pathBackBottom.lineWidth = 5;
    _pathBackBottom.strokeColor = rockBackgroundColor;
    _pathBackBottom.fillColor = rockBackgroundColor;
//    _pathBackBottom.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:_pathBackBottom.path];
//    _pathBackBottom.physicsBody.affectedByGravity = NO;
//    _pathBackBottom.physicsBody.categoryBitMask = wallCategory;
//    _pathBackBottom.physicsBody.contactTestBitMask = balloonCategory;
//    _pathBackBottom.physicsBody.collisionBitMask = balloonCategory;

    [self addChild:_pathBackBottom];

    UIColor *rockLineColor = [UIColor blackColor];
    UIColor *rockColor = [UIColor systemGray6Color];

    _pathTop = [SKShapeNode shapeNodeWithPoints:topPoints count:1000];
    _pathTop.lineWidth = 3;
    _pathTop.strokeColor = rockLineColor;
    _pathTop.fillColor = rockColor;
    _pathTop.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:_pathTop.path];
    _pathTop.physicsBody.affectedByGravity = NO;
    _pathTop.physicsBody.categoryBitMask = wallCategory;
    _pathTop.physicsBody.contactTestBitMask = balloonCategory;
    _pathTop.physicsBody.collisionBitMask = balloonCategory;

    [self addChild:_pathTop];

    _pathBottom = [SKShapeNode shapeNodeWithPoints:bottomPoints count:1000];
    _pathBottom.lineWidth = 3;
    _pathBottom.strokeColor = rockLineColor;
    _pathBottom.fillColor = rockColor;
    _pathBottom.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:_pathBottom.path];
    _pathBottom.physicsBody.affectedByGravity = NO;
    _pathBottom.physicsBody.categoryBitMask = wallCategory;
    _pathBottom.physicsBody.contactTestBitMask = balloonCategory;
    _pathBottom.physicsBody.collisionBitMask = balloonCategory;

    [self addChild:_pathBottom];

    [self scrollCaveBy:-view.frame.size.width];
    [self updatePositionForPercentage:0];

    [self preloadEmitter];

    _scrollSpeed = 0;
}

- (void)preloadEmitter {
    _popEmitter = [SKEmitterNode nodeWithFileNamed:@"pop"];
}

- (void)update:(NSTimeInterval)currentTime {
    [self scrollCaveBy:self.scrollSpeed];
}

- (void)scrollCaveBy:(CGFloat)scrollAmount {
    CGPoint topPosition = self.pathTop.position;
    topPosition.x = topPosition.x - scrollAmount;
    self.pathTop.position = topPosition;

    CGPoint bottomPosition = self.pathBottom.position;
    bottomPosition.x = bottomPosition.x - scrollAmount;
    self.pathBottom.position = bottomPosition;

    CGPoint topBackPosition = self.pathBackTop.position;
    topBackPosition.x = topBackPosition.x - scrollAmount/2;
    self.pathBackTop.position = topBackPosition;

    CGPoint bottomBackPosition = self.pathBackBottom.position;
    bottomBackPosition.x = bottomBackPosition.x - scrollAmount/2;
    self.pathBackBottom.position = bottomBackPosition;
}

- (void)updatePositionForPercentage:(CGFloat)percentage {
    CGFloat yPosition = percentage * self.size.height - self.size.height/2;
    CGPoint balloonPosition = CGPointMake(-self.size.width/4, yPosition);
    self.balloon.position = balloonPosition;
}

// MARK: -
- (void)didBeginContact:(SKPhysicsContact *)contact {
    self.scrollSpeed = 0;

    SKEmitterNode *emitterCopy = [self.popEmitter copy];
    emitterCopy.position = self.balloon.position;
    [self addChild:emitterCopy];

    [self.balloon removeFromParent];

    [emitterCopy runAction:[SKAction sequence:
                                @[
        [SKAction scaleBy:1.5 duration:0.2],
        [SKAction runBlock:^{

            emitterCopy.particleBirthRate = 0;
            [SKAction waitForDuration:1];

            [SKAction runBlock:^{
                [emitterCopy removeFromParent];
            }];
    }]]
                           ]];
}

@end
