//  Created by Dominik Hauser on 01.11.24.
//  
//


#import "DDHBalloonAnchor.h"

@implementation DDHBalloonAnchor
+ (instancetype)anchorNodeWithDaysLeft:(NSInteger)daysLeft {
    CGSize size;
//    if (daysLeft < 100) {
//        size = CGSizeMake(16, 16);
//    } else {
        size = CGSizeMake(8, 8);
//    }
    DDHBalloonAnchor *node = [super shapeNodeWithEllipseOfSize:size];
    node.daysLeft = daysLeft;
    node.fillColor = [UIColor whiteColor];
    node.zPosition = 2;

//    if (daysLeft < 100) {
//        SKLabelNode *label = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%ld", daysLeft]];
//        label.fontSize = 13;
//        label.fontName = [UIFont systemFontOfSize:13 weight:UIFontWeightHeavy].fontName;
//        label.fontColor = [UIColor blackColor];
//        label.position = CGPointMake(0, -label.frame.size.height/2);
//        [node addChild:label];
//    }

    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.mass = 99999999999;
    node.physicsBody.categoryBitMask = kNilOptions;
    return node;
}
@end
