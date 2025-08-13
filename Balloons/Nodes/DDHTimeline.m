//  Created by Dominik Hauser on 29.10.24.
//  
//


#import "DDHTimeline.h"

@implementation DDHTimeline

- (instancetype)initWithStartPoint:(CGPoint)start andEndPoint:(CGPoint)end {
    if (self = [super init]) {
        [self updateWithStartPoint:start andEndPoint:end];
    }
    return self;
}

- (void)updateWithStartPoint:(CGPoint)start andEndPoint:(CGPoint)end {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint startWithYOffset = CGPointMake(start.x, start.y + 20);
    [path moveToPoint:startWithYOffset];
    [path addLineToPoint:start];
    [path addLineToPoint:end];

    SKLabelNode *todayLabelNode = [SKLabelNode labelNodeWithText:@"Today"];
    todayLabelNode.zRotation = M_PI_2;
    todayLabelNode.fontSize = 22;
    todayLabelNode.position = CGPointMake(startWithYOffset.x + 9, startWithYOffset.y + 30);
    [self addChild:todayLabelNode];

    self.path = [path CGPath];

    self.strokeColor = UIColor.whiteColor;
    self.lineWidth = 2;
    self.zPosition = 1;
}

@end
