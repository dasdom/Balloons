//  Created by Dominik Hauser on 22.12.24.
//  
//


#import "DDHBirthdayInputView.h"

@implementation DDHBirthdayInputView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButtonConfiguration *buttonConfiguration = [UIButtonConfiguration filledButtonConfiguration];
        buttonConfiguration.title = @"Import From Contacts";
        _importButton = [UIButton buttonWithConfiguration:buttonConfiguration primaryAction:nil];

        UILabel *orLabel = [[UILabel alloc] init];
        orLabel.text = @"or";
        orLabel.textAlignment = NSTextAlignmentCenter;

        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor secondarySystemFillColor];

        UIView *imageViewHostView = [[UIView alloc] init];
        [imageViewHostView addSubview:_imageView];

        _givenNameTextField = [[UITextField alloc] init];
        _givenNameTextField.placeholder = @"Given name";
        _givenNameTextField.borderStyle = UITextBorderStyleRoundedRect;

        _familyNameTextField = [[UITextField alloc] init];
        _familyNameTextField.placeholder = @"Family name";
        _familyNameTextField.borderStyle = UITextBorderStyleRoundedRect;

        _birthdayPicker = [[UIDatePicker alloc] init];
        _birthdayPicker.datePickerMode = UIDatePickerModeDate;

        UIStackView *inputStackView = [[UIStackView alloc] initWithArrangedSubviews:@[_importButton, orLabel, imageViewHostView, _givenNameTextField, _familyNameTextField, _birthdayPicker]];
        inputStackView.axis = UILayoutConstraintAxisVertical;
        inputStackView.spacing = 10;

        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_importButton, orLabel, inputStackView]];
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.spacing = 20;

        self.backgroundColor = [UIColor systemBackgroundColor];

        [self addSubview:stackView];

        CGFloat imageViewWidth = 80;

        [NSLayoutConstraint activateConstraints:@[
            [stackView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:10],
            [stackView.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor constant:16],
            [stackView.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-16],

            [_imageView.topAnchor constraintEqualToAnchor:imageViewHostView.topAnchor constant:8],
            [_imageView.bottomAnchor constraintEqualToAnchor:imageViewHostView.bottomAnchor constant:-8],
            [_imageView.centerXAnchor constraintEqualToAnchor:imageViewHostView.centerXAnchor],
            [_imageView.widthAnchor constraintEqualToConstant:imageViewWidth],
            [_imageView.heightAnchor constraintEqualToAnchor:_imageView.widthAnchor]
        ]];
    }
    return self;
}
@end
