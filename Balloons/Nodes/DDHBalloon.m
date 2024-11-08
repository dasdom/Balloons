//  Created by Dominik Hauser on 27.10.24.
//
//


#import "DDHBalloon.h"
#import "UIImage+Extenstion.h"
#import "DDHBirthday.h"

@interface DDHBalloon ()
@property (nonatomic, strong) DDHBirthday *birthday;
@property (nonatomic, strong) SKLabelNode *nameLabel;
@property (nonatomic, strong) SKSpriteNode *background;
@end

@implementation DDHBalloon

- (instancetype)initWithBirthday:(DDHBirthday *)birthday width:(CGFloat)width {
    if (self = [super init]) {
        self.birthday = birthday;

        UIImage *image = [UIImage imageWithData:birthday.imageData];
        UIImage *roundedImage = [image roundedWithColor:[UIColor whiteColor] width:10 targetSize:CGSizeMake(500, 500)];
        SKTexture *texture = [SKTexture textureWithImage:roundedImage];
        self.texture = texture;
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.size = CGSizeMake(width, width);

        _nameLabel = [SKLabelNode labelNodeWithText:birthday.personNameComponents.givenName];
        _nameLabel.numberOfLines = 0;
        _nameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _nameLabel.fontSize = 13;
        _nameLabel.fontName = [UIFont systemFontOfSize:13 weight:UIFontWeightHeavy].fontName;
        _nameLabel.position = CGPointMake(0, -_nameLabel.frame.size.height/2);
        _nameLabel.fontColor = [UIColor blackColor];

        _background = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(_nameLabel.frame.size.width + 6, _nameLabel.frame.size.height)];
        _background.position = CGPointMake(0, -self.size.height/2);
        [_background addChild:_nameLabel];

        [self addChild:_background];

        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:width/2];
        self.physicsBody.angularDamping = 0.9;
        self.physicsBody.categoryBitMask = 1 << 1;
        self.physicsBody.collisionBitMask = 1 << 1;
    }
    return self;
}

- (DDHBalloon *)balloonCopy {
    return [[DDHBalloon alloc] initWithBirthday:self.birthday width:self.size.width];
}

- (void)showLabel:(BOOL)show animated:(BOOL)animated {
    if (animated) {
        CGFloat alpha = show ? 1 : 0;
        [self.background runAction:[SKAction fadeAlphaTo:alpha duration:0.3]];
    } else {
        self.background.alpha = show ? 1 : 0;
    }
}

- (void)showInfoWithNameFormatter:(NSPersonNameComponentsFormatter *)nameFormatter dateFormatter:(NSDateFormatter *)dateFormatter {
    nameFormatter.style = NSPersonNameComponentsFormatterStyleMedium;
    self.nameLabel.text = [NSString stringWithFormat:@"%@\n%@", [nameFormatter stringFromPersonNameComponents:self.birthday.personNameComponents], [dateFormatter stringFromDate:self.birthday.date]];
    self.nameLabel.fontSize = 15;
    self.nameLabel.fontName = [UIFont systemFontOfSize:15 weight:UIFontWeightHeavy].fontName;
    self.nameLabel.position = CGPointMake(0, -self.nameLabel.frame.size.height/2);

    self.background.position = CGPointMake(0, -self.size.height/2);
    self.background.size = CGSizeMake(self.nameLabel.frame.size.width + 16, self.nameLabel.frame.size.height + 4);
    [self showLabel:YES animated:YES];
}

@end
