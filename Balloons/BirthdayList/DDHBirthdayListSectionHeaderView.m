//  Created by Dominik Hauser on 17.01.25.
//  
//


#import "DDHBirthdayListSectionHeaderView.h"

@interface DDHBirthdayListSectionHeaderView ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation DDHBirthdayListSectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _label = [[UILabel alloc] init];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
//        _label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];

        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;

        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect style:UIVibrancyEffectStyleFill];
        UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = NO;

        [vibrancyEffectView.contentView addSubview:_label];
        [blurEffectView.contentView addSubview:vibrancyEffectView];
        [self addSubview:blurEffectView];

        [NSLayoutConstraint activateConstraints:@[
            [vibrancyEffectView.topAnchor constraintEqualToAnchor:blurEffectView.contentView.topAnchor],
            [vibrancyEffectView.leadingAnchor constraintEqualToAnchor:blurEffectView.contentView.leadingAnchor],
            [vibrancyEffectView.bottomAnchor constraintEqualToAnchor:blurEffectView.contentView.bottomAnchor],
            [vibrancyEffectView.trailingAnchor constraintEqualToAnchor:blurEffectView.contentView.trailingAnchor],

            [blurEffectView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [blurEffectView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [blurEffectView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
            [blurEffectView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

            [_label.topAnchor constraintEqualToAnchor:vibrancyEffectView.contentView.topAnchor],
            [_label.leadingAnchor constraintEqualToAnchor:vibrancyEffectView.contentView.leadingAnchor constant:10],
            [_label.bottomAnchor constraintEqualToAnchor:vibrancyEffectView.contentView.bottomAnchor],
            [_label.trailingAnchor constraintEqualToAnchor:vibrancyEffectView.contentView.trailingAnchor],
        ]];
    }
    return self;
}

- (void)updateWithName:(NSString *)name {
    self.label.text = name;
}
@end
