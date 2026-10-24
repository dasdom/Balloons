//  Created by Dominik Hauser on 22.12.24.
//  
//


#import "DDHBirthdayInputView.h"

@interface DDHBirthdayInputView ()
@property (nonatomic, strong) UIStackView *orStackView;
@property (nonatomic, strong) UIView *imageViewHostView;
@end

@implementation DDHBirthdayInputView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButtonConfiguration *buttonConfiguration = [UIButtonConfiguration filledButtonConfiguration];
        buttonConfiguration.title = @"Import From Contacts";
        _importButton = [UIButton buttonWithConfiguration:buttonConfiguration primaryAction:nil];
        _importButton.clipsToBounds = YES;

        UIView *leftDividerView = [[UIView alloc] init];
        leftDividerView.backgroundColor = [UIColor secondaryLabelColor];

        UIView *rightDividerView = [[UIView alloc] init];
        rightDividerView.backgroundColor = [UIColor secondaryLabelColor];

        UILabel *orLabel = [[UILabel alloc] init];
        orLabel.text = @"or";
        orLabel.textAlignment = NSTextAlignmentCenter;

        _orStackView = [[UIStackView alloc] initWithArrangedSubviews:@[leftDividerView, orLabel, rightDividerView]];
        _orStackView.spacing = 10;
        _orStackView.alignment = UIStackViewAlignmentCenter;

        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.userInteractionEnabled = YES;
        _imageView.backgroundColor = [UIColor secondarySystemFillColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.image = [UIImage systemImageNamed:@"person.fill"];

        _imageViewHostView = [[UIView alloc] init];
        _imageViewHostView.clipsToBounds = YES;
        [_imageViewHostView addSubview:_imageView];

        _emojiTextField = [[DDHEmojiTextField alloc] init];
        _emojiTextField.placeholder = @"Emoji";
        _emojiTextField.borderStyle = UITextBorderStyleRoundedRect;
        _emojiTextField.font = [UIFont systemFontOfSize:30];
        _emojiTextField.textAlignment = NSTextAlignmentCenter;
        _emojiTextField.hidden = YES;

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

        UIStackView *inputStackView = [[UIStackView alloc] initWithArrangedSubviews:@[_imageViewHostView, _emojiTextField, _givenNameTextField, _familyNameTextField, _birthdayPicker, _addButton]];
        inputStackView.axis = UILayoutConstraintAxisVertical;
        inputStackView.spacing = 10;

        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_importButton, _orStackView, inputStackView]];
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.spacing = 20;

        self.backgroundColor = [UIColor colorNamed:@"backgroundColor"];

        [self addSubview:stackView];

        CGFloat imageViewWidth = 80;

        [NSLayoutConstraint activateConstraints:@[
            [stackView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:10],
            [stackView.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor constant:16],
            [stackView.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-16],

            [leftDividerView.heightAnchor constraintEqualToConstant:1],
            [leftDividerView.widthAnchor constraintEqualToAnchor:rightDividerView.widthAnchor],
            [rightDividerView.heightAnchor constraintEqualToAnchor:leftDividerView.heightAnchor],

            [_imageView.topAnchor constraintEqualToAnchor:_imageViewHostView.topAnchor constant:8],
            [_imageView.bottomAnchor constraintEqualToAnchor:_imageViewHostView.bottomAnchor constant:-8],
            [_imageView.centerXAnchor constraintEqualToAnchor:_imageViewHostView.centerXAnchor],
            [_imageView.widthAnchor constraintEqualToConstant:imageViewWidth],
            [_imageView.heightAnchor constraintEqualToAnchor:_imageView.widthAnchor]
        ]];
    }
    return self;
}

- (void)updateWithInputType:(DDHInputType)inputType {
    self.imageView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        switch (inputType) {
            case DDHInputTypeEvent:
                self.importButton.hidden = YES;
                self.orStackView.hidden = YES;
                self.imageViewHostView.hidden = YES;
                self.familyNameTextField.hidden = YES;
                self.givenNameTextField.placeholder = @"Event name";

                self.emojiTextField.hidden = NO;
                break;
            default:
                self.importButton.hidden = NO;
                self.orStackView.hidden = NO;
                self.imageViewHostView.hidden = NO;
                self.familyNameTextField.hidden = NO;
                self.givenNameTextField.placeholder = @"Given name";

                self.emojiTextField.hidden = YES;
                break;
        }
    } completion:^(BOOL finished) {
        switch (inputType) {
            case DDHInputTypeBirthday:
                self.imageView.hidden = NO;
                break;
            default:
                break;
        }
    }];
}
@end
