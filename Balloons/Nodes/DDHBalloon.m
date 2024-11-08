//  Created by Dominik Hauser on 27.10.24.
//
//


#import "DDHBalloon.h"
#import "UIImage+Extenstion.h"

@interface DDHBalloon ()
@property (nonatomic, strong) NSData *imageData;
@end

@implementation DDHBalloon

- (instancetype)initWithImage:(NSData *)imageData width:(CGFloat)width birthdayId:(NSUUID *)birthdayId {
    if (self = [super init]) {
        self.imageData = imageData;
        self.birthdayId = birthdayId;

        UIImage *image = [UIImage imageWithData:imageData];
        UIImage *roundedImage = [image roundedWithColor:[UIColor whiteColor] width:1 targetSize:CGSizeMake(500, 500)];
        SKTexture *texture = [SKTexture textureWithImage:roundedImage];
        self.texture = texture;
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.size = CGSizeMake(width, width);

        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:width/2];
        self.physicsBody.angularDamping = 0.9;
    }
    return self;
}

- (DDHBalloon *)balloonCopy {
    return [[DDHBalloon alloc] initWithImage:self.imageData width:self.size.width birthdayId:self.birthdayId];
}

@end
