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
@property (nonatomic, strong) SKSpriteNode *labelBackground;
@property (nonatomic, strong) UIColor *balloonColor;
@end

@implementation DDHBalloon

- (instancetype)initWithBirthday:(DDHBirthday *)birthday width:(CGFloat)width color:(UIColor *)color {
    if (self = [super init]) {
        self.birthdayId = birthday.uuid;
        self.birthday = birthday;
        self.balloonColor = color;

        UIImage *roundedImage;
        if (birthday.imageData) {
            UIImage *image = [UIImage imageWithData:birthday.imageData];
            roundedImage = [image roundedWithColor:[UIColor whiteColor] width:10 targetSize:CGSizeMake(400, 400)];
        } else {
            roundedImage = [UIImage initialsImageWithPersonNameComponents:birthday.personNameComponents color:color];
        }
        SKTexture *texture = [SKTexture textureWithImage:roundedImage];
        self.texture = texture;
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.size = CGSizeMake(width, width);
        self.zPosition = 500 - birthday.daysLeft;

        self.isAccessibilityElement = YES;
        self.accessibilityLabel = birthday.personNameComponents.givenName;

        _deleteButtonNode = [[SKSpriteNode alloc] initWithImageNamed:@"trash"];
        _deleteButtonNode.position = CGPointMake(200/3, 200/3);
        _deleteButtonNode.size = CGSizeMake(40, 40);
        _deleteButtonNode.color = [UIColor tintColor];
        _deleteButtonNode.blendMode = SKBlendModeAlpha;
        _deleteButtonNode.colorBlendFactor = 1;
        _deleteButtonNode.hidden = YES;
        _deleteButtonNode.name = @"delete";
        [self addChild:_deleteButtonNode];

        _nameLabel = [SKLabelNode labelNodeWithText:birthday.personNameComponents.givenName];
        _nameLabel.numberOfLines = 0;
        _nameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _nameLabel.fontSize = 13;
        _nameLabel.fontName = [UIFont systemFontOfSize:13 weight:UIFontWeightHeavy].fontName;
        _nameLabel.fontColor = [UIColor blackColor];
        _nameLabel.position = CGPointMake(0, -_nameLabel.frame.size.height/2);

        _labelBackground = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(_nameLabel.frame.size.width + 2, _nameLabel.frame.size.height)];
        _labelBackground.position = CGPointMake(0, -self.size.height/2);
        [_labelBackground addChild:_nameLabel];

        [self addChild:_labelBackground];

        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:width/2];
        self.physicsBody.angularDamping = 0.9;
        self.physicsBody.linearDamping = 0.9;
        self.physicsBody.categoryBitMask = 1 << 0;
        self.physicsBody.collisionBitMask = 1 << 1;
    }
    return self;
}

- (DDHBalloon *)balloonCopyForDetail {
    DDHBalloon *balloon = [[DDHBalloon alloc] initWithBirthday:self.birthday width:self.size.width color:self.balloonColor];
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
        [self.labelBackground runAction:[SKAction fadeAlphaTo:alpha duration:0.3]];
    } else {
        self.labelBackground.alpha = show ? 1 : 0;
    }
}

- (void)showInfoWithNameFormatter:(NSPersonNameComponentsFormatter *)nameFormatter dateFormatterWithYear:(NSDateFormatter *)dateFormatterWithYear dateFormatterWithoutYear:(NSDateFormatter *)dateFormatterWithoutYear {
    nameFormatter.style = NSPersonNameComponentsFormatterStyleMedium;
    NSString *nameString = [nameFormatter stringFromPersonNameComponents:self.birthday.personNameComponents];
    if (self.birthday.yearUnknown) {
        NSString *dateString = [dateFormatterWithoutYear stringFromDate:self.birthday.date];
        self.nameLabel.text = [NSString stringWithFormat:@"%@\n%@\nin %ld days",
                               nameString,
                               dateString,
                               self.birthday.daysLeft
        ];
    } else {
        NSString *dateString = [dateFormatterWithYear stringFromDate:self.birthday.date];
        self.nameLabel.text = [NSString stringWithFormat:@"%@\n%@\nturns %ld in %ld days",
                               nameString,
                               dateString,
                               [DDHDateHelper ageForDateComponents:self.birthday.date] + 1,
                               self.birthday.daysLeft
        ];
    }
    self.nameLabel.fontSize = 15;
    self.nameLabel.fontName = [UIFont systemFontOfSize:15 weight:UIFontWeightHeavy].fontName;
    self.nameLabel.position = CGPointMake(0, -self.nameLabel.frame.size.height/2);

    self.labelBackground.position = CGPointMake(0, -self.size.height/2);
    self.labelBackground.size = CGSizeMake(self.nameLabel.frame.size.width + 16, self.nameLabel.frame.size.height + 4);
    [self showLabel:YES animated:YES];
}

@end
