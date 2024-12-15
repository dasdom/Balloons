//  Created by Dominik Hauser on 29.10.24.
//  
//


#import "DDHTimeline.h"

@implementation DDHTimeline

- (instancetype)initWithStartPoint:(CGPoint)start andEndPoint:(CGPoint)end {
    if (self = [super init]) {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        CGPoint startWithYOffset = CGPointMake(start.x, start.y + 5);
        [path moveToPoint:startWithYOffset];
        [path addLineToPoint:start];
        [path addLineToPoint:end];

        self.path = [path CGPath];

        self.strokeColor = UIColor.whiteColor;
        self.lineWidth = 2;
        self.zPosition = 1;
    }
    return self;
}

- (void)updateWithStartPoint:(CGPoint)start andEndPoint:(CGPoint)end {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:start];
    [path addLineToPoint:end];

    self.path = [path CGPath];
}

@end
