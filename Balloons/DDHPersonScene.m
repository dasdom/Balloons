//  Created by Dominik Hauser on 07.11.24.
//  
//


#import "DDHPersonScene.h"
#import "DDHBirthday.h"
#import "DDHBalloon.h"

@interface DDHPersonScene ()
@property (nonatomic, strong) DDHBirthday *birthday;
@end

@implementation DDHPersonScene

- (instancetype)initWithSize:(CGSize)size birthday:(DDHBirthday *)birthday {
    if (self = [super initWithSize:size]) {
        _birthday = birthday;

        self.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    UIImage *backImage = [UIImage systemImageNamed:@"arrow.left"];
    SKTexture *texture = [SKTexture textureWithImage:backImage];
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:texture];
    spriteNode.position = CGPointMake(-view.frame.size.width/2 + 50, view.frame.size.height/2 - 100);
    [self addChild:spriteNode];

    DDHBalloon *balloon = [[DDHBalloon alloc] initWithImage:self.birthday.imageData width:200 birthdayId:self.birthday.uuid];
    balloon.physicsBody.affectedByGravity = NO;
    balloon.position = self.position;
    [self addChild:balloon];
}

@end
