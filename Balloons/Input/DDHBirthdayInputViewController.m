//  Created by Dominik Hauser on 22.12.24.
//  
//


#import "DDHBirthdayInputViewController.h"
#import "DDHBirthdayInputView.h"
#import "DDHBirthday.h"

@interface DDHBirthdayInputViewController () <UITextFieldDelegate>
@property (nonatomic, weak) id<DDHBirthdayInputViewControllerProtocol> delegate;
@property (nonatomic, weak) DDHBirthdayInputView *contentView;
@property (nonatomic, strong) NSString *givenName;
@property (nonatomic, strong) NSString *familyName;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) UIImage *image;
@end

@implementation DDHBirthdayInputViewController

- (instancetype)initWithDelegate:(id<DDHBirthdayInputViewControllerProtocol>)delegate {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _delegate = delegate;
    }
    return self;
}

- (void)loadView {
    self.view = [[DDHBirthdayInputView alloc] init];
}

- (DDHBirthdayInputView *)contentView {
    return (DDHBirthdayInputView *)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Input";

    self.date = self.contentView.birthdayPicker.date;

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;

    [self.contentView.importButton addTarget:self action:@selector(importSelected:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSelected:)];
    [self.contentView.imageView addGestureRecognizer:tapRecognizer];

    self.contentView.givenNameTextField.delegate = self;
    self.contentView.familyNameTextField.delegate = self;

    [self.contentView.birthdayPicker addTarget:self action:@selector(updateDate:) forControlEvents:UIControlEventValueChanged];

    [self.contentView.addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.contentView.imageView.image = image;
}

- (BOOL)isInputValid {
    if ([self.givenName length] < 1) {
        return NO;
    } else if (nil == self.date) {
        return NO;
    }
    return YES;
}

// MARK: - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.contentView.givenNameTextField]) {
        [self.contentView.familyNameTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }

    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *text = [textField.text mutableCopy];

    [text replaceCharactersInRange:range withString:string];

    if ([textField isEqual:self.contentView.givenNameTextField]) {
        self.givenName = text;
    } else if ([textField isEqual:self.contentView.familyNameTextField]) {
        self.familyName = text;
    }

    self.contentView.addButton.enabled = [self isInputValid];

    return YES;
}

// MARK: - Actions
- (void)importSelected:(UIButton *)sender {
    [self.delegate didSelectImportFromContactsInViewController:self];
}

- (void)imageSelected:(UITapGestureRecognizer *)sender {
    [self.delegate didSelectPhotoInViewController:self];
}

- (void)updateDate:(UIDatePicker *)sender {
    self.date = sender.date;

    self.contentView.addButton.enabled = [self isInputValid];
}

- (void)add:(UIButton *)sender {
    NSPersonNameComponents *personComponents = [[NSPersonNameComponents alloc] init];
    personComponents.givenName = self.givenName;
    personComponents.familyName = self.familyName;
    DDHBirthday *birthday = [[DDHBirthday alloc] initWithUUID:[NSUUID UUID] date:self.date personNameComponents:personComponents yearUnknown:NO];

    if (self.image) {
        NSData *imageData = UIImageJPEGRepresentation(self.image, 0.5);
        [birthday saveImageData:imageData personUUID:birthday.uuid];
    }

    [self.delegate didSelectAddInViewController:self withBirthday:birthday];
}

- (void)cancel:(UIButton *)sender {
    [self.delegate didSelectCancelInViewController:self];
}

@end
