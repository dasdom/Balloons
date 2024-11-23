//  Created by Dominik Hauser on 23.11.24.
//  
//


#import "DDHNumberOfShownDaysCell.h"

@implementation DDHNumberOfShownDaysCell

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *shownDaysLabel = [[UILabel alloc] init];
        shownDaysLabel.text = @"Shown days";
        shownDaysLabel.textColor = [UIColor whiteColor];
        shownDaysLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];

        _daysSegmentedControl = [[UISegmentedControl alloc] init];
        _daysSegmentedControl.selectedSegmentIndex = 2;
        _daysSegmentedControl.selectedSegmentTintColor = [UIColor systemOrangeColor];
        [_daysSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor systemOrangeColor]} forState:UIControlStateNormal];
        [_daysSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateSelected];

        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[shownDaysLabel, _daysSegmentedControl]];
        stackView.spacing = 8;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.axis = UILayoutConstraintAxisVertical;

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
