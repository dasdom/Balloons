//  Created by Dominik Hauser on 25.04.25.
//  
//

#import "DDHPresentsListViewController.h"
#import "DDHPresentsListView.h"
#import "DDHStorage.h"
#import "DDHEmptyPresentListCell.h"
#import "DDHPresentCell.h"
#import "DDHPresent.h"
#import "DDHBirthday.h"
#import "NSArray+Functions.h"
#import <SafariServices/SafariServices.h>

@interface DDHPresentsListViewController () <UITableViewDelegate>
@property (nonatomic, strong) id<DDHPresentsListViewControllerProtocol> delegate;
@property (nonatomic, strong) DDHBirthday *birthday;
@property (nonatomic, strong) DDHStorage *storage;
@property (nonatomic, strong) NSArray<DDHPresent *> *presents;
@property (nonatomic, strong) DDHPresentsListView *contentView;
@property (nonatomic, strong) UITableViewDiffableDataSource *dataSource;
@property (nonatomic, strong) NSPersonNameComponentsFormatter *nameFormatter;
@property (nonatomic, strong) NSUUID *emptyInfoUUID;
@end

@implementation DDHPresentsListViewController

- (instancetype)initWithDelegate:(id<DDHPresentsListViewControllerProtocol>)delegate birthday:(DDHBirthday *)birthday storage:(DDHStorage *)storage {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _delegate = delegate;
        _birthday = birthday;
        _storage = storage;

        _nameFormatter = [[NSPersonNameComponentsFormatter alloc] init];
        _nameFormatter.style = NSPersonNameComponentsFormatterStyleMedium;
    }
    return self;
}

- (void)loadView {
    self.view = [[DDHPresentsListView alloc] init];
}

- (DDHPresentsListView *)contentView {
    return (DDHPresentsListView *)self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Present ideas";
    self.navigationItem.prompt = [NSString stringWithFormat:@"for %@", [self.nameFormatter stringFromPersonNameComponents:self.birthday.personNameComponents]];

    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.leftBarButtonItem = done;

    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = add;

    UITableView *tableView = self.contentView.tableView;

    tableView.delegate = self;

    [tableView registerClass:[DDHEmptyPresentListCell class] forCellReuseIdentifier:[DDHEmptyPresentListCell identifier]];
    [tableView registerClass:[DDHPresentCell class] forCellReuseIdentifier:[DDHPresentCell identifier]];

    _dataSource = [[UITableViewDiffableDataSource alloc] initWithTableView:tableView cellProvider:^UITableViewCell * _Nullable(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, NSUUID * _Nonnull itemIdentifier) {

        UITableViewCell *cell;

        if ([itemIdentifier.UUIDString isEqualToString:self.emptyInfoUUID.UUIDString]) {
            DDHEmptyPresentListCell *emptyListCell = [tableView dequeueReusableCellWithIdentifier:[DDHEmptyPresentListCell identifier] forIndexPath:indexPath];
            cell = emptyListCell;
        } else {
            NSUInteger index = [self.presents indexOfObjectPassingTest:^BOOL(DDHPresent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [obj.uuid.UUIDString isEqualToString:itemIdentifier.UUIDString];
            }];
            DDHPresent *present = self.presents[index];

            DDHPresentCell *presentCell = [tableView dequeueReusableCellWithIdentifier:[DDHPresentCell identifier] forIndexPath:indexPath];

            [presentCell updateWithPresent:present];
            cell = presentCell;
        }

        return cell;
    }];

    [self loadAndUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        NSIndexPath *selectedIndexPath = [self.contentView.tableView indexPathForSelectedRow];
        [self.contentView.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    } completion:nil];
}

- (void)loadAndUpdate {
    NSArray<DDHPresent *> *presents = [self.storage presentsForBirthday:self.birthday];
    [self updateWithPresents:presents];
}

- (void)updateWithPresents:(NSArray<DDHPresent *> *)presents {
    self.presents = presents;

    NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
    [snapshot appendSectionsWithIdentifiers:@[@"Main"]];
    NSArray<NSUUID *> *ids = [self.presents map:^NSUUID * _Nonnull(DDHPresent * _Nonnull present) {
        return present.uuid;
    }];
    if ([ids count] > 0) {
        [snapshot appendItemsWithIdentifiers:ids];
    } else {
        _emptyInfoUUID = [NSUUID UUID];
        [snapshot appendItemsWithIdentifiers:@[_emptyInfoUUID]];
    }
    [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
}

// MARK: - UITableViewDelegate
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {

        NSUUID *itemIdentifier = [self.dataSource itemIdentifierForIndexPath:indexPath];
        NSUInteger index = [self.presents indexOfObjectPassingTest:^BOOL(DDHPresent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.uuid.UUIDString isEqualToString:itemIdentifier.UUIDString];
        }];
        DDHPresent *present = self.presents[index];
        [self.storage deletePresent:present];

        [self loadAndUpdate];
        completionHandler(YES);
    }];
    return [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUUID *itemIdentifier = [self.dataSource itemIdentifierForIndexPath:indexPath];
    NSUInteger index = [self.presents indexOfObjectPassingTest:^BOOL(DDHPresent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.uuid.UUIDString isEqualToString:itemIdentifier.UUIDString];
    }];
    DDHPresent *present = self.presents[index];

    if (present.url.host.length > 0) {
        SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:present.url];
        [self presentViewController:safariViewController animated:YES completion:nil];
    }
}

// MARK: - Actions
- (void)add:(UIBarButtonItem *)sender {
    [self.delegate viewControllerDidSelectAdd:self birthday:self.birthday storage:self.storage];
}

- (void)done:(UIBarButtonItem *)sender {
    [self.delegate viewControllerDidDone:self];
}

@end
