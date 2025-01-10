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

        UIView *leftDividerView = [[UIView alloc] init];
        leftDividerView.backgroundColor = [UIColor secondaryLabelColor];

        UIView *rightDividerView = [[UIView alloc] init];
        rightDividerView.backgroundColor = [UIColor secondaryLabelColor];

        UILabel *orLabel = [[UILabel alloc] init];
        orLabel.text = @"or";
        orLabel.textAlignment = NSTextAlignmentCenter;

        UIStackView *orStackView = [[UIStackView alloc] initWithArrangedSubviews:@[leftDividerView, orLabel, rightDividerView]];
        orStackView.spacing = 10;
        orStackView.alignment = UIStackViewAlignmentCenter;

        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.userInteractionEnabled = YES;
        _imageView.backgroundColor = [UIColor secondarySystemFillColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.image = [UIImage systemImageNamed:@"person.fill"];

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

        buttonConfiguration.title = @"Add manually";
        _addButton = [UIButton buttonWithConfiguration:buttonConfiguration primaryAction:nil];
        _addButton.enabled = NO;

        UIStackView *inputStackView = [[UIStackView alloc] initWithArrangedSubviews:@[imageViewHostView, _givenNameTextField, _familyNameTextField, _birthdayPicker, _addButton]];
        inputStackView.axis = UILayoutConstraintAxisVertical;
        inputStackView.spacing = 10;

        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_importButton, orStackView, inputStackView]];
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

            [leftDividerView.heightAnchor constraintEqualToConstant:1],
            [leftDividerView.widthAnchor constraintEqualToAnchor:rightDividerView.widthAnchor],
            [rightDividerView.heightAnchor constraintEqualToAnchor:leftDividerView.heightAnchor],

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
