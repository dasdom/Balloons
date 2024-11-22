//  Created by Dominik Hauser on 17.11.24.
//  
//


#import "DDHSettingsViewController.h"
#import "DDHSettingsView.h"
#import "NSUserDefaults+Extension.h"

@interface DDHSettingsViewController ()
@property (nonatomic, strong) id<DDHSettingsViewControllerDelegate> delegate;
@end

@implementation DDHSettingsViewController

- (instancetype)initWithDelegate:(id<DDHSettingsViewControllerDelegate>)delegate {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _delegate = delegate;
    }
    return self;
}

- (void)loadView {
    self.view = [[DDHSettingsView alloc] init];
}

- (DDHSettingsView *)contentView {
    return (DDHSettingsView *)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"xmark"] style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    self.navigationItem.rightBarButtonItem = closeButton;

    [self.contentView.daysSegmentedControl addTarget:self action:@selector(changeDays:) forControlEvents:UIControlEventValueChanged];

    NSInteger numberOfShownDays = [[NSUserDefaults standardUserDefaults] numberOfShownDays];
    switch (numberOfShownDays) {
        case 30:
            self.contentView.daysSegmentedControl.selectedSegmentIndex = 0;
            break;
        case 90:
            self.contentView.daysSegmentedControl.selectedSegmentIndex = 1;
            break;
        default:
            self.contentView.daysSegmentedControl.selectedSegmentIndex = 2;
            break;
    }
}

// MARK: - Actions
- (void)close:(UIBarButtonItem *)sender {
    [self.delegate didSelectCloseInViewController:self];
}

- (void)changeDays:(UISegmentedControl *)sender {
    NSInteger numberOfShownDays;
    switch (sender.selectedSegmentIndex) {
        case 0:
            numberOfShownDays = 30;
            break;
        case 1:
            numberOfShownDays = 90;
            break;
        default:
            numberOfShownDays = 280;
            break;
    }
    [[NSUserDefaults standardUserDefaults] setNumberOfShownDays:numberOfShownDays];
    [self.delegate didChangeNumberOfShownDays:self numberOfShownDays:numberOfShownDays];
}

@end
