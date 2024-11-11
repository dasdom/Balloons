//  Created by Dominik Hauser on 27.10.24.
//
//


#import "DDHBalloon.h"
#import "UIImage+Extension.h"
#import "DDHBirthday.h"
#import "DDHDateHelper.h"

@interface DDHBalloon ()
@property (nonatomic, strong) DDHBirthday *birthday;
@property (nonatomic, strong) SKLabelNode *nameLabel;
@property (nonatomic, strong) SKSpriteNode *background;
@end

@implementation DDHBalloon

- (instancetype)initWithBirthday:(DDHBirthday *)birthday width:(CGFloat)width {
    if (self = [super init]) {
        self.birthday = birthday;

        UIImage *roundedImage;
        if (birthday.imageData) {
            UIImage *image = [UIImage imageWithData:birthday.imageData];
            roundedImage = [image roundedWithColor:[UIColor whiteColor] width:10 targetSize:CGSizeMake(500, 500)];
        } else {
            roundedImage = [UIImage initialsImageWithPersonNameComponents:birthday.personNameComponents];
        }
        SKTexture *texture = [SKTexture textureWithImage:roundedImage];
        self.texture = texture;
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.size = CGSizeMake(width, width);
        self.zPosition = 500 - birthday.daysLeft;

        _nameLabel = [SKLabelNode labelNodeWithText:birthday.personNameComponents.givenName];
        _nameLabel.numberOfLines = 0;
        _nameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _nameLabel.fontSize = 14;
        _nameLabel.fontName = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy].fontName;
        _nameLabel.fontColor = [UIColor blackColor];
        _nameLabel.position = CGPointMake(0, -_nameLabel.frame.size.height/2);

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

- (DDHBalloon *)balloonCopyForDetail {
    DDHBalloon *balloon = [[DDHBalloon alloc] initWithBirthday:self.birthday width:self.size.width];
    balloon.position = self.position;
    balloon.physicsBody.allowsRotation = NO;
    balloon.physicsBody.affectedByGravity = NO;
    balloon.physicsBody.categoryBitMask = 1 << 2;
    balloon.physicsBody.collisionBitMask = 1 << 2;
    [balloon showLabel:NO animated:NO];
    return balloon;
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
    self.nameLabel.text = [NSString stringWithFormat:@"%@\n%@\nturns %ld in %ld days", [
        nameFormatter stringFromPersonNameComponents:self.birthday.personNameComponents],
                           [dateFormatter stringFromDate:self.birthday.date],
                           [DDHDateHelper ageForDateComponents:self.birthday.date] + 1,
                           self.birthday.daysLeft
    ];
    self.nameLabel.fontSize = 15;
    self.nameLabel.fontName = [UIFont systemFontOfSize:15 weight:UIFontWeightHeavy].fontName;
    self.nameLabel.position = CGPointMake(0, -self.nameLabel.frame.size.height/2);

    self.background.position = CGPointMake(0, -self.size.height/2);
    self.background.size = CGSizeMake(self.nameLabel.frame.size.width + 16, self.nameLabel.frame.size.height + 4);
    [self showLabel:YES animated:YES];
}

@end
