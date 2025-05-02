//  Created by Dominik Hauser on 27.04.25.
//  
//


#import "DDHPresentInputViewController.h"
#import "DDHPresentInputView.h"
#import "DDHPresent.h"
#import "DDHBirthday.h"
#import "DDHStorage.h"

@interface DDHPresentInputViewController () <UITextFieldDelegate>
@property (nonatomic, weak) id<DDHPresentInputViewControllerProtocol> delegate;
@property (nonatomic, strong) DDHBirthday *birthday;
@property (nonatomic, strong) DDHStorage *storage;
@property (nonatomic, strong) DDHPresentInputView *contentView;
@end

@implementation DDHPresentInputViewController
- (instancetype)initWithDelegate:(id<DDHPresentInputViewControllerProtocol>)delegate birthday:(DDHBirthday *)birthday storage:(DDHStorage *)storage {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _delegate = delegate;
        _birthday = birthday;
        _storage = storage;
    }
    return self;
}

- (void)loadView {
    self.view = [[DDHPresentInputView alloc] init];
}

- (DDHPresentInputView *)contentView {
    return (DDHPresentInputView *)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Add present idea";

    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.leftBarButtonItem = done;

    self.contentView.titleTextField.delegate = self;
    [self.contentView.addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.contentView.titleTextField becomeFirstResponder];
}

// MARK: - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *text = [textField.text mutableCopy];

    [text replaceCharactersInRange:range withString:string];

    self.contentView.addButton.enabled = text.length > 0;

    return YES;
}

// MARK: - Actions
- (void)add:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:self.contentView.urlTextField.text];
    DDHPresent *present = [[DDHPresent alloc] initWithUUID:[NSUUID UUID] birthdayUUID:self.birthday.uuid url:url title:self.contentView.titleTextField.text givenAwayDate:nil priority:0 note:self.contentView.noteTextView.text];
    [self.storage insertPresent:present];

    [self.delegate viewControllerDidAddPresent:self];
}

- (void)done:(UIBarButtonItem *)sender {
    [self.delegate viewControllerDidDone:self];
}
@end
