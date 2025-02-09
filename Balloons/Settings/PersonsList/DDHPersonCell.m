//  Created by Dominik Hauser on 24.01.25.
//  
//


#import "DDHPersonCell.h"
#import "DDHBirthday.h"
#import "UIImage+Extension.h"

@interface DDHPersonCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *balloonButton;
@end

@implementation DDHPersonCell

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat cornerRadius = 20;
        _avatarImageView.layer.cornerRadius = cornerRadius;
        _avatarImageView.layer.masksToBounds = YES;

        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

        UIButtonConfiguration *buttonConfiguration = [UIButtonConfiguration plainButtonConfiguration];
        buttonConfiguration.image = [UIImage systemImageNamed:@"balloon"];
        _balloonButton = [UIButton buttonWithConfiguration:buttonConfiguration primaryAction:nil];
        _balloonButton.userInteractionEnabled = NO;

        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_avatarImageView, _nameLabel, _balloonButton]];
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.spacing = 8;

        [self.contentView addSubview:stackView];

        [NSLayoutConstraint activateConstraints:@[
            [stackView.topAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.topAnchor],
            [stackView.leadingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leadingAnchor],
            [stackView.bottomAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.bottomAnchor],
            [stackView.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor],

            [_avatarImageView.widthAnchor constraintEqualToConstant:cornerRadius*2],
            [_avatarImageView.heightAnchor constraintEqualToAnchor:_avatarImageView.widthAnchor],
        ]];
    }
    return self;
}

- (void)updateWithBirthday:(DDHBirthday *)birthday nameFormatter:(NSPersonNameComponentsFormatter *)nameFormatter {
    UIImage *roundedImage;
    if (birthday.imageData) {
        UIImage *image = [UIImage imageWithData:birthday.imageData];
        roundedImage = [image roundedWithColor:[UIColor whiteColor] width:10 targetSize:CGSizeMake(400, 400)];
    } else {
        CGFloat hue = birthday.daysLeft/366.0;
        roundedImage = [UIImage initialsImageWithPersonNameComponents:birthday.personNameComponents color:[UIColor colorWithHue:hue saturation:0.7 brightness:0.7 alpha:1]];
    }
    self.avatarImageView.image = roundedImage;

    self.nameLabel.text = [nameFormatter stringFromPersonNameComponents:birthday.personNameComponents];

    UIButtonConfiguration *buttonConfiguration = [self.balloonButton configuration];
    buttonConfiguration.image = birthday.favorite ? [UIImage systemImageNamed:@"balloon.fill"] : [UIImage systemImageNamed:@"balloon"];
    self.balloonButton.configuration = buttonConfiguration;
}

@end
