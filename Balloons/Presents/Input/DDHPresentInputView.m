//  Created by Dominik Hauser on 27.04.25.
//  
//


#import "DDHPresentInputView.h"

@implementation DDHPresentInputView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleTextField = [[UITextField alloc] init];
        _titleTextField.placeholder = @"Title";

        _urlTextField = [[UITextField alloc] init];
        _urlTextField.placeholder = @"Link";

        _noteTextView = [[UITextView alloc] init];

        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_titleTextField, _urlTextField, _noteTextView]];
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.spacing = 8;

        self.backgroundColor = [UIColor systemGray6Color];

        [self addSubview:stackView];

        [NSLayoutConstraint activateConstraints:@[
            [stackView.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor],
            [stackView.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor],
            [stackView.bottomAnchor constraintEqualToAnchor:self.keyboardLayoutGuide.topAnchor constant:-10],
            [stackView.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
        ]];
    }
    return self;
}
@end
