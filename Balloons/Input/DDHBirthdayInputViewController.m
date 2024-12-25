//  Created by Dominik Hauser on 22.12.24.
//  
//


#import "DDHBirthdayInputViewController.h"
#import "DDHBirthdayInputView.h"

@interface DDHBirthdayInputViewController ()
@property (nonatomic, weak) id<DDHBirthdayInputViewControllerProtocol> delegate;
@property (nonatomic, weak) DDHBirthdayInputView *contentView;
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

    [self.contentView.importButton addTarget:self action:@selector(importSelected:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSelected:)];
    [self.contentView.imageView addGestureRecognizer:tapRecognizer];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)setImage:(UIImage *)image {
    self.contentView.imageView.image = image;
}

// MARK: - Actions
- (void)importSelected:(UIButton *)sender {
    [self.delegate didSelectImportFromContactsInViewController:self];
}

- (void)imageSelected:(UITapGestureRecognizer *)sender {
    [self.delegate didSelectPhotoInViewController:self];
}

- (void)cancel:(UIButton *)sender {
    [self.delegate didSelectCancelInViewController:self];
}

@end
