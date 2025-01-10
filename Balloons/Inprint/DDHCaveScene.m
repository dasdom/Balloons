//  Created by Dominik Hauser on 01.01.25.
//  
//


#import "DDHCaveScene.h"
#import "DDHBalloon.h"

@interface DDHCaveScene ()
@property (nonatomic, strong) DDHBalloon *balloon;
@property (nonatomic, strong) SKShapeNode *pathTop;
@property (nonatomic, strong) SKShapeNode *pathBottom;
@property (nonatomic, assign) CGFloat *scrollSpeed;
@end

@implementation DDHCaveScene

- (void)didMoveToView:(SKView *)view {
    CGPoint topPoints[1000];
    CGPoint bottomPoints[1000];

    uint32_t wallCategory = 1 << 1;
    uint32_t balloonCategory = 1 << 2;

    CGFloat x = -self.size.width/2.0;
    topPoints[0] = CGPointMake(x, self.size.height/2.0-20);
    bottomPoints[0] = CGPointMake(x, -self.size.height/2.0);

    CGFloat previousYTop = 0;
    CGFloat previousYBottom = 0;

    for (NSUInteger i=1; i<1000; i++) {
        x += 40;

        CGFloat yTopStep = arc4random_uniform(60)-30;
        CGFloat yTop = MIN(MAX(previousYTop + yTopStep, -100), 280);
        topPoints[i] = CGPointMake(x, yTop);
        previousYTop = yTop;

        CGFloat yBottomStep = arc4random_uniform(60)-30;
        CGFloat yBottom = MIN(MAX(previousYBottom + yBottomStep, -100), yTop - 80);
        bottomPoints[i] = CGPointMake(x, yBottom);
        previousYBottom = yBottom;
    }

    _pathTop = [SKShapeNode shapeNodeWithPoints:topPoints count:1000];
    _pathTop.lineWidth = 5;
    _pathTop.strokeColor = [UIColor whiteColor];
    _pathTop.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:_pathTop.path];
    _pathTop.physicsBody.affectedByGravity = NO;
    _pathTop.physicsBody.categoryBitMask = wallCategory;
    _pathTop.physicsBody.contactTestBitMask = balloonCategory;
    _pathTop.physicsBody.collisionBitMask = balloonCategory;

    [self addChild:_pathTop];

    _pathBottom = [SKShapeNode shapeNodeWithPoints:bottomPoints count:1000];
    _pathBottom.lineWidth = 5;
    _pathBottom.strokeColor = [UIColor whiteColor];
    _pathBottom.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:_pathBottom.path];
    _pathBottom.physicsBody.affectedByGravity = NO;
    _pathBottom.physicsBody.categoryBitMask = wallCategory;
    _pathBottom.physicsBody.contactTestBitMask = balloonCategory;
    _pathBottom.physicsBody.collisionBitMask = balloonCategory;

    [self addChild:_pathBottom];
}

@end
