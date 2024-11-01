//  Created by Dominik Hauser on 27.10.24.
//  
//


#import <SpriteKit/SpriteKit.h>

@class DDHBirthday;

@interface GameScene : SKScene
- (void)updateForBirthdays:(NSArray<DDHBirthday *> *)birthdays;
@end
