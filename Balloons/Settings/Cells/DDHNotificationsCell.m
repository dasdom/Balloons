//  Created by Dominik Hauser on 23.11.24.
//  
//


#import "DDHNotificationsCell.h"

@interface DDHNotificationsCell ()
@end

@implementation DDHNotificationsCell

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *notificationsLabel = [[UILabel alloc] init];
        notificationsLabel.text = @"Notify a week before";
        notificationsLabel.textColor = [UIColor whiteColor];
        notificationsLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];

        _notificationSwitch = [[UISwitch alloc] init];
        _notificationSwitch.onTintColor = [UIColor tintColor];

        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[notificationsLabel, _notificationSwitch]];
        stackView.translatesAutoresizingMaskIntoConstraints = NO;

        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:stackView];

        [NSLayoutConstraint activateConstraints:@[
            [stackView.topAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.topAnchor],
            [stackView.leadingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.leadingAnchor],
            [stackView.bottomAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.bottomAnchor],
            [stackView.trailingAnchor constraintEqualToAnchor:self.contentView.layoutMarginsGuide.trailingAnchor],
        ]];
    }
    return self;
}

@end
