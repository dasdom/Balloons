//  Created by Dominik Hauser on 27.10.24.
//
//


#import "DDHBalloon.h"

@implementation DDHBalloon

- (instancetype)initWithWidth:(CGFloat)width {
    if (self = [super init]) {
        CGPathRef path = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, width, width), nil);
        self.path = path;

        self.fillColor = UIColor.redColor;

        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        self.physicsBody.angularDamping = 0.9;
        self.physicsBody.fieldBitMask = 1 << 1;
    }
    return self;
}

@end
