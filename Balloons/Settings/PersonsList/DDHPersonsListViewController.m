//  Created by Dominik Hauser on 24.01.25.
//  
//


#import "DDHPersonsListViewController.h"
#import "DDHPersonsListView.h"
#import "DDHBirthday.h"
#import "DDHPersonCell.h"
#import "NSArray+Functions.h"
#import "DDHStorage.h"
#import "NSUserDefaults+Extension.h"

@interface DDHPersonsListViewController () <UITableViewDelegate>
@property (nonatomic, strong) id<DDHPersonsListViewControllerProtocol> delegate;
@property (nonatomic, strong) DDHPersonsListView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DDHStorage *storage;
@property (nonatomic, strong) NSArray<DDHBirthday *> *birthdays;
@property (nonatomic, strong) UITableViewDiffableDataSource *dataSource;
@property (nonatomic, strong) NSPersonNameComponentsFormatter *nameFormatter;
@end

@implementation DDHPersonsListViewController

- (instancetype)initWithDelegate:(id<DDHPersonsListViewControllerProtocol>)delegate storage:(nonnull DDHStorage *)storage {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _delegate = delegate;
        _storage = storage;

        _nameFormatter = [[NSPersonNameComponentsFormatter alloc] init];
        _nameFormatter.style = NSPersonNameComponentsFormatterStyleMedium;
    }
    return self;
}


- (void)loadView {
    self.view = [[DDHPersonsListView alloc] init];
}

- (DDHPersonsListView *)contentView {
    return (DDHPersonsListView *)self.view;
}

- (UITableView *)tableView {
    return self.contentView.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.birthdays = [self.storage birthdays];

    [self.tableView registerClass:[DDHPersonCell class] forCellReuseIdentifier:[DDHPersonCell identifier]];

    _dataSource = [[UITableViewDiffableDataSource alloc] initWithTableView:self.tableView cellProvider:^UITableViewCell * _Nullable(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {

        DDHPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:[DDHPersonCell identifier] forIndexPath:indexPath];

        DDHBirthday *birthday = [self.birthdays firstObjectPassingTest:^BOOL(DDHBirthday * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return (obj.uuid == itemIdentifier);
        }];

        [cell updateWithBirthday:birthday nameFormatter:self.nameFormatter];

        return cell;
    }];

    self.tableView.delegate = self;

    [self updateWithBirthdays:self.birthdays];
}

- (void)updateWithBirthdays:(NSArray<DDHBirthday *> *)birthdays {
    [self updateWithBirthdays:birthdays reloadBirthdays:@[]];
}

- (void)updateWithBirthdays:(NSArray<DDHBirthday *> *)birthdays reloadBirthdays:(NSArray<DDHBirthday *> *)reloadBirthdays {
    NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
    [snapshot appendSectionsWithIdentifiers:@[@"Main"]];
    NSArray<NSUUID *> *uuids = [birthdays map:^id _Nonnull(DDHBirthday * _Nonnull input) {
        return input.uuid;
    }];
    [snapshot appendItemsWithIdentifiers:uuids];

    NSArray<NSUUID *> *uuidsToReload = [reloadBirthdays map:^id _Nonnull(DDHBirthday * _Nonnull input) {
        return input.uuid;
    }];
    [snapshot reloadItemsWithIdentifiers:uuidsToReload];

    [self.dataSource applySnapshot:snapshot animatingDifferences:NO];
}

- (void)showTooManyBirthdaysAlert {
    NSString *title = NSLocalizedString(@"too_many_birthdays_alert_title", @"too_many_birthdays_alert_title");
    NSString *message = NSLocalizedString(@"too_many_birthdays_alert_message", @"too_many_birthdays_alert_message");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    NSString *okActionTitle = NSLocalizedString(@"general_ok", @"general_ok");
    [alert addAction:[UIAlertAction actionWithTitle:okActionTitle style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUUID *itemIdentifier = [self.dataSource itemIdentifierForIndexPath:indexPath];
    DDHBirthday *birthday = [self.birthdays firstObjectPassingTest:^BOOL(DDHBirthday * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return (obj.uuid == itemIdentifier);
    }];

    NSArray<DDHBirthday *> *favoriteBirthdays = [self.birthdays filter:^BOOL(DDHBirthday * _Nonnull birthday) {
        return birthday.favorite;
    }];
    NSInteger maximumNumberOfBalloons = [[NSUserDefaults standardUserDefaults] maximumNumberOfBalloons];

    if ([favoriteBirthdays count] >= maximumNumberOfBalloons) {
        [self showTooManyBirthdaysAlert];
    } else {
        birthday.favorite = !birthday.favorite;
        [self.storage updateFavorite:birthday.favorite forBirthday:birthday];
        [self.delegate reloadBirthdaysFromViewController:self];
        [self updateWithBirthdays:self.birthdays reloadBirthdays:@[birthday]];
    }
}

@end
