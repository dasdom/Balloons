//  Created by Dominik Hauser on 17.11.24.
//  
//


#import "DDHSettingsViewController.h"
#import "DDHSettingsView.h"
#import "NSUserDefaults+Extension.h"
#import "DDHNumberOfShownDaysCell.h"
#import "DDHNotificationsCell.h"
#import "DDHSettingsCellIdentifier.h"
#import <UserNotifications/UserNotifications.h>
#import "DDHBirthday.h"
#import "DDHNumberOfShownDays.h"

@interface DDHSettingsViewController () <UITableViewDelegate>
@property (nonatomic, strong) id<DDHSettingsViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray<DDHBirthday *> *birthdays;
@property (nonatomic, strong) UITableViewDiffableDataSource *dataSource;
@end

const NSInteger DDHIndexForDays[] = {
    [DDHNumberOfShownDaysThirty] = 0,
    [DDHNumberOfShownDaysNinety] = 1,
    [DDHNumberOfShownDaysTwoHundredEighty] = 2,
    [DDHNumberOfShownDaysThreeHundredSixty] = 3
};

@implementation DDHSettingsViewController

- (instancetype)initWithDelegate:(id<DDHSettingsViewControllerDelegate>)delegate birthdays:(NSArray<DDHBirthday *> *)birthdays {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _delegate = delegate;
        _birthdays = birthdays;
    }
    return self;
}

- (void)loadView {
    self.view = [[DDHSettingsView alloc] init];
}

- (DDHSettingsView *)contentView {
    return (DDHSettingsView *)self.view;
}

- (UITableView *)tableView {
    return self.contentView.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Settings";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"xmark"] style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    self.navigationItem.rightBarButtonItem = closeButton;

    self.tableView.delegate = self;

    [self.tableView registerClass:[DDHNumberOfShownDaysCell class] forCellReuseIdentifier:[DDHNumberOfShownDaysCell identifier]];
    [self.tableView registerClass:[DDHNotificationsCell class] forCellReuseIdentifier:[DDHNotificationsCell identifier]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    _dataSource = [[UITableViewDiffableDataSource alloc] initWithTableView:self.tableView cellProvider:^UITableViewCell * _Nullable(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, NSNumber *  _Nonnull itemIdentifier) {

        UITableViewCell *cell;
        switch (itemIdentifier.integerValue) {
            case DDHSettingsCellIdentifierNumberOfShownDays:
            {
                DDHNumberOfShownDaysCell *shownDaysCell = [tableView dequeueReusableCellWithIdentifier:[DDHNumberOfShownDaysCell identifier] forIndexPath:indexPath];

                [shownDaysCell.daysSegmentedControl insertSegmentWithTitle:[NSString stringWithFormat:@"%ld days", DDHNumberOfShownDaysThirty] atIndex:DDHIndexForDays[DDHNumberOfShownDaysThirty] animated:NO];
                [shownDaysCell.daysSegmentedControl insertSegmentWithTitle:[NSString stringWithFormat:@"%ld days", DDHNumberOfShownDaysNinety] atIndex:DDHIndexForDays[DDHNumberOfShownDaysNinety] animated:NO];
                if ([self.birthdays count] < 200) {
                    [shownDaysCell.daysSegmentedControl insertSegmentWithTitle:[NSString stringWithFormat:@"%ld days", DDHNumberOfShownDaysTwoHundredEighty] atIndex:DDHIndexForDays[DDHNumberOfShownDaysTwoHundredEighty] animated:NO];
                    [shownDaysCell.daysSegmentedControl insertSegmentWithTitle:[NSString stringWithFormat:@"%ld days", DDHNumberOfShownDaysThreeHundredSixty] atIndex:DDHIndexForDays[DDHNumberOfShownDaysThreeHundredSixty] animated:NO];
                }

                if ([[shownDaysCell.daysSegmentedControl allTargets] count] < 1) {
                    [shownDaysCell.daysSegmentedControl addTarget:self action:@selector(changeDays:) forControlEvents:UIControlEventValueChanged];
                }

                NSInteger numberOfShownDays = [[NSUserDefaults standardUserDefaults] numberOfShownDays];
                BOOL shouldUpdateSegmentedControl = NO;
                if ([self.birthdays count] >= 200) {
                    if (numberOfShownDays > 100) {
                        numberOfShownDays = DDHNumberOfShownDaysNinety;
                        [[NSUserDefaults standardUserDefaults] setNumberOfShownDays:numberOfShownDays];
                        shouldUpdateSegmentedControl = YES;
                    }
                }
                shownDaysCell.daysSegmentedControl.selectedSegmentIndex = DDHIndexForDays[numberOfShownDays];

                if (shouldUpdateSegmentedControl) {
                    [self changeDays:shownDaysCell.daysSegmentedControl];
                }

                cell = shownDaysCell;
                break;
            }
            case DDHSettingsCellIdentifierNotifications:
            {
                DDHNotificationsCell *notificationCell = [tableView dequeueReusableCellWithIdentifier:[DDHNotificationsCell identifier] forIndexPath:indexPath];

                if ([[notificationCell.notificationSwitch allTargets] count] < 1) {
                    [notificationCell.notificationSwitch addTarget:self action:@selector(changeNotificationsActive:) forControlEvents:UIControlEventValueChanged];
                }

                notificationCell.notificationSwitch.on = [[NSUserDefaults standardUserDefaults] notificationsActive];

                cell = notificationCell;
                break;
            }
            case DDHSettingsCellIdentifierPersons:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
                cell.textLabel.text = @"Shown Balloons";
                break;
            }
            default:
                NSAssert(NO, @"Unexpected");
                break;
        }
        return cell;
    }];

    [self update];
}

- (void)update {
    NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
    [snapshot appendSectionsWithIdentifiers:@[@"Main"]];
    [snapshot appendItemsWithIdentifiers:@[@(DDHSettingsCellIdentifierNumberOfShownDays), @(DDHSettingsCellIdentifierNotifications), @(DDHSettingsCellIdentifierPersons)]];
    [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
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
        case DDHIndexForDays[DDHNumberOfShownDaysThreeHundredSixty]:
            numberOfShownDays = DDHNumberOfShownDaysThreeHundredSixty;
            break;
        default:
            numberOfShownDays = DDHNumberOfShownDaysTwoHundredEighty;
            break;
    }
    [[NSUserDefaults standardUserDefaults] setNumberOfShownDays:numberOfShownDays];
    [self.delegate didChangeNumberOfShownDays:self numberOfShownDays:numberOfShownDays];
}

- (void)changeNotificationsActive:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setNotificationsActive:sender.on];

    if (sender.on) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {

                for (DDHBirthday *birthday in self.birthdays) {
                    UNNotificationRequest* request = [birthday notificationRequest];

                    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
                    [center addNotificationRequest:request withCompletionHandler:nil];
                }
            }
        }];
    } else {
//        [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
//            NSLog(@"requests %@", requests);
//        }];
        [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    }
}

// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DDHSettingsCellIdentifier cellIdentifier = [[self.dataSource itemIdentifierForIndexPath:indexPath] integerValue];
    if (cellIdentifier == DDHSettingsCellIdentifierPersons) {
        [self.delegate didSelectPersonsInViewController:self birthdays:self.birthdays];
    }
}

@end
