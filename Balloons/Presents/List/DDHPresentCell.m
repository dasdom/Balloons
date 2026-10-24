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
@property (nonatomic, strong) UILabel *givenAwayDate;
@end

@implementation DDHPresentCell

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _titleLabel.textColor = [UIColor whiteColor];

        _urlLabel = [[UILabel alloc] init];
        _urlLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _urlLabel.textColor = [UIColor whiteColor];

        _givenAwayDate = [[UILabel alloc] init];
        _givenAwayDate.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _givenAwayDate.textColor = [UIColor secondaryLabelColor];

        _note = [[UILabel alloc] init];
        _note.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _note.numberOfLines = 3;
        _note.textColor = [UIColor whiteColor];

        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_titleLabel, _urlLabel, _givenAwayDate, _note]];
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.spacing = 4;

        self.backgroundColor = [UIColor colorNamed:@"backgroundColor"];

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

- (void)updateWithPresent:(DDHPresent *)present dateFormatter:(NSDateFormatter *)dateFormatter {

    if ([present.givenAwayDate timeIntervalSince1970] > 1) {
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:present.title attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody], NSForegroundColorAttributeName: [UIColor secondaryLabelColor]}];
        self.titleLabel.attributedText = attributedTitle;
        self.givenAwayDate.text = [NSString stringWithFormat:@"Marked as given away %@", [dateFormatter stringFromDate: present.givenAwayDate]];

        self.givenAwayDate.hidden = NO;
        self.urlLabel.hidden = YES;
        self.note.hidden = YES;
    } else {
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:present.title attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody], NSForegroundColorAttributeName: [UIColor labelColor]}];
        self.titleLabel.attributedText = attributedTitle;

        if (present.url.absoluteString.length > 0) {
            self.urlLabel.text = present.url.absoluteString;
            self.urlLabel.hidden = NO;
        } else {
            self.urlLabel.hidden = YES;
        }

        if (present.note.length > 0) {
            self.note.text = present.note;
            self.note.hidden = NO;
        } else {
            self.note.hidden = YES;
        }

        self.givenAwayDate.hidden = YES;
    }
}

@end
