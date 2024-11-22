//  Created by Dominik Hauser on 17.11.24.
//  
//


#import "DDHSettingsViewController.h"
#import "DDHSettingsView.h"
#import "NSUserDefaults+Extension.h"

@interface DDHSettingsViewController ()
@property (nonatomic, strong) id<DDHSettingsViewControllerDelegate> delegate;
@end

const NSInteger DDHIndexForDays[] = {
    [DDHNumberOfShownDaysThirty] = 0,
    [DDHNumberOfShownDaysNinety] = 1,
    [DDHNumberOfShownDaysTwoHundredEighty] = 2
};

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

    [self.contentView.daysSegmentedControl insertSegmentWithTitle:[NSString stringWithFormat:@"%ld days", DDHNumberOfShownDaysThirty] atIndex:DDHIndexForDays[DDHNumberOfShownDaysThirty] animated:NO];
    [self.contentView.daysSegmentedControl insertSegmentWithTitle:[NSString stringWithFormat:@"%ld days", DDHNumberOfShownDaysNinety] atIndex:DDHIndexForDays[DDHNumberOfShownDaysNinety] animated:NO];
    [self.contentView.daysSegmentedControl insertSegmentWithTitle:[NSString stringWithFormat:@"%ld days", DDHNumberOfShownDaysTwoHundredEighty] atIndex:DDHIndexForDays[DDHNumberOfShownDaysTwoHundredEighty] animated:NO];

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"xmark"] style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    self.navigationItem.rightBarButtonItem = closeButton;

    [self.contentView.daysSegmentedControl addTarget:self action:@selector(changeDays:) forControlEvents:UIControlEventValueChanged];

    NSInteger numberOfShownDays = [[NSUserDefaults standardUserDefaults] numberOfShownDays];
    switch (numberOfShownDays) {
        case DDHNumberOfShownDaysThirty:
            self.contentView.daysSegmentedControl.selectedSegmentIndex = DDHIndexForDays[DDHNumberOfShownDaysThirty];
            break;
        case DDHNumberOfShownDaysNinety:
            self.contentView.daysSegmentedControl.selectedSegmentIndex = DDHIndexForDays[DDHNumberOfShownDaysNinety];
            break;
        case DDHNumberOfShownDaysTwoHundredEighty:
            self.contentView.daysSegmentedControl.selectedSegmentIndex = DDHIndexForDays[DDHNumberOfShownDaysTwoHundredEighty];
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
        case DDHIndexForDays[DDHNumberOfShownDaysThirty]:
            numberOfShownDays = DDHNumberOfShownDaysThirty;
            break;
        case DDHIndexForDays[DDHNumberOfShownDaysNinety]:
            numberOfShownDays = DDHNumberOfShownDaysNinety;
            break;
        case DDHIndexForDays[DDHNumberOfShownDaysTwoHundredEighty]:
            numberOfShownDays = DDHNumberOfShownDaysTwoHundredEighty;
            break;
        default:
            numberOfShownDays = DDHNumberOfShownDaysTwoHundredEighty;
            break;
    }
    [[NSUserDefaults standardUserDefaults] setNumberOfShownDays:numberOfShownDays];
    [self.delegate didChangeNumberOfShownDays:self numberOfShownDays:numberOfShownDays];
}

@end
