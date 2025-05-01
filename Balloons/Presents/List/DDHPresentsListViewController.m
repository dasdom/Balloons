//  Created by Dominik Hauser on 25.04.25.
//  
//

#import "DDHPresentsListViewController.h"
#import "DDHPresentsListView.h"
#import "DDHStorage.h"
#import "DDHPresentCell.h"
#import "DDHPresent.h"
#import "DDHBirthday.h"
#import "NSArray+Functions.h"

@interface DDHPresentsListViewController ()
@property (nonatomic, strong) id<DDHPresentsListViewControllerProtocol> delegate;
@property (nonatomic, strong) DDHBirthday *birthday;
@property (nonatomic, strong) DDHStorage *storage;
@property (nonatomic, strong) NSArray<DDHPresent *> *presents;
@property (nonatomic, strong) DDHPresentsListView *contentView;
@property (nonatomic, strong) UITableViewDiffableDataSource *dataSource;
@property (nonatomic, strong) NSPersonNameComponentsFormatter *nameFormatter;
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
    self.navigationItem.prompt = [self.nameFormatter stringFromPersonNameComponents:self.birthday.personNameComponents];

    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancel;

    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = add;

    UITableView *tableView = self.contentView.tableView;

    [tableView registerClass:[DDHPresentCell class] forCellReuseIdentifier:[DDHPresentCell identifier]];

    _dataSource = [[UITableViewDiffableDataSource alloc] initWithTableView:tableView cellProvider:^UITableViewCell * _Nullable(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, NSUUID * _Nonnull itemIdentifier) {

        NSUInteger index = [self.presents indexOfObjectPassingTest:^BOOL(DDHPresent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.uuid.UUIDString isEqualToString:itemIdentifier.UUIDString];
        }];
        DDHPresent *present = self.presents[index];

        DDHPresentCell *cell = [tableView dequeueReusableCellWithIdentifier:[DDHPresentCell identifier] forIndexPath:indexPath];

        [cell updateWithPresent:present];

        return cell;
    }];

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
    }
    [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
}

// MARK: - Actions
- (void)add:(UIBarButtonItem *)sender {
    [self.delegate viewControllerDidSelectAdd:self];
}

- (void)cancel:(UIBarButtonItem *)sender {
    [self.delegate viewControllerDidCancel:self];
}

@end
