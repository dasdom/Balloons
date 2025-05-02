//  Created by Dominik Hauser on 01.05.25.
//  
//


#import "DDHEmptyPresentListCell.h"

@interface DDHEmptyPresentListCell ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation DDHEmptyPresentListCell
+ (NSString *)identifier {
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _label = [[UILabel alloc] init];
        _label.numberOfLines = 0;
        _label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"No presents ideas yet. Add ideas with the plus button.";

        UIImage *arrowImage = [UIImage systemImageNamed:@"arrow.turn.right.up"];
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
        UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:24];
        arrowImageView.preferredSymbolConfiguration = config;
        arrowImageView.tintColor = [UIColor labelColor];

        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_label, arrowImageView]];
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.spacing = 8;
        stackView.alignment = UIStackViewAlignmentCenter;

        [self.contentView addSubview:stackView];

        [arrowImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [arrowImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

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
