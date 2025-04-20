//  Created by Dominik Hauser on 19.04.25.
//  
//


#import "DDHStartScene.h"

@implementation DDHStartScene

- (void)didMoveToView:(SKView *)view {
    SKLabelNode *titleNode = [SKLabelNode labelNodeWithText:@"Balloon"];
    titleNode.fontColor = [UIColor whiteColor];
    titleNode.fontSize = 40;
    titleNode.position = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame));
    titleNode.name = @"title";

    [self addChild:titleNode];

    SKLabelNode *descriptionNode = [SKLabelNode labelNodeWithText:@"Scroll to move balloon"];
    descriptionNode.fontColor = [UIColor whiteColor];
    descriptionNode.fontSize = 27;
    descriptionNode.position = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame) - 40);
    descriptionNode.name = @"description";

    [self addChild:descriptionNode];

    self.scaleMode = SKSceneScaleModeAspectFit;
}

@end
