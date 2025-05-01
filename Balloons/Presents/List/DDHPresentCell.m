//  Created by Dominik Hauser on 27.04.25.
//  
// ┌───────────────────────────────┐
// │ Title                         │
// │                               │
// │ https://present.com/          │
// │                               │
// │ Note that helps to understand │
// │ the present                   │
// └───────────────────────────────┘

#import "DDHPresentCell.h"
#import "DDHPresent.h"

@interface DDHPresentCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UILabel *note;
@end

@implementation DDHPresentCell

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

        _urlLabel = [[UILabel alloc] init];
        _urlLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];

        _note = [[UILabel alloc] init];
        _note.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _note.numberOfLines = 3;

        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_titleLabel, _urlLabel, _note]];
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.spacing = 8;

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

- (void)updateWithPresent:(DDHPresent *)present {
    self.titleLabel.text = present.title;
    self.urlLabel.text = present.url.absoluteString;
    self.note.text = present.note;
}

@end
