//  Created by Dominik Hauser on 27.04.25.
//  
//


#import "DDHPresentInputView.h"

@implementation DDHPresentInputView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleTextField = [[UITextField alloc] init];
        _titleTextField.placeholder = @"Title";
        _titleTextField.borderStyle = UITextBorderStyleRoundedRect;
//        _titleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Title" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
//        _titleTextField.textColor = [UIColor whiteColor];

        _urlTextField = [[UITextField alloc] init];
        _urlTextField.placeholder = @"Link";
        _urlTextField.borderStyle = UITextBorderStyleRoundedRect;
        _urlTextField.keyboardType = UIKeyboardTypeURL;
        _urlTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _urlTextField.autocorrectionType = UITextAutocorrectionTypeNo;
//        _urlTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Link" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
//        _urlTextField.textColor = [UIColor whiteColor];

        UILabel *noteKeyLabel = [[UILabel alloc] init];
        noteKeyLabel.text = @"Note:";
        noteKeyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        noteKeyLabel.textColor = [UIColor lightGrayColor];

        _noteTextView = [[UITextView alloc] init];
        _noteTextView.layer.cornerRadius = 4;
        _noteTextView.backgroundColor = [UIColor systemBackgroundColor];

        UIStackView *noteStackView = [[UIStackView alloc] initWithArrangedSubviews:@[noteKeyLabel, _noteTextView]];
        noteStackView.axis = UILayoutConstraintAxisVertical;
        noteStackView.spacing = 4;

        UIButtonConfiguration *buttonConfig = [UIButtonConfiguration filledButtonConfiguration];
        buttonConfig.title = @"Add";
        _addButton = [UIButton buttonWithConfiguration:buttonConfig primaryAction:nil];
        _addButton.enabled = NO;

        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_titleTextField, _urlTextField, noteStackView, _addButton]];
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.spacing = 8;

        self.backgroundColor = [UIColor colorNamed:@"backgroundColor"];

        [self addSubview:stackView];

        [NSLayoutConstraint activateConstraints:@[
            [stackView.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor],
            [stackView.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor],
//            [stackView.bottomAnchor constraintEqualToAnchor:self.keyboardLayoutGuide.topAnchor constant:-10],
            [stackView.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],

            [_noteTextView.heightAnchor constraintEqualToConstant:100],
        ]];
    }
    return self;
}
@end
