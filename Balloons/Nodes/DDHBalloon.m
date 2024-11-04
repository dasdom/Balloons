//  Created by Dominik Hauser on 27.10.24.
//
//


#import "DDHBalloon.h"
#import "UIImage+Extenstion.h"

@implementation DDHBalloon

- (instancetype)initWithImage:(NSData *)imageData width:(CGFloat)width daysLeft:(NSInteger)daysLeft {
    if (self = [super init]) {
        UIImage *image = [UIImage imageWithData:imageData];
        UIImage *roundedImage = [image roundedWithColor:[UIColor whiteColor] width:1 targetSize:CGSizeMake(300, 300)];
        SKTexture *texture = [SKTexture textureWithImage:roundedImage];
//        SKSpriteNode *imageNode = [SKSpriteNode spriteNodeWithTexture:texture];
//        //        imageNode.zRotation = -45 * M_PI / 180;
        self.texture = texture;
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.size = CGSizeMake(width, width);

        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:width/2];
        self.physicsBody.angularDamping = 0.9;
        self.physicsBody.fieldBitMask = 1 << 1;

        self.daysLeft = daysLeft;
    }
    return self;
}

@end
