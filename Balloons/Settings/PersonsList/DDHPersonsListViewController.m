//  Created by Dominik Hauser on 24.01.25.
//  
//


#import "DDHPersonsListViewController.h"
#import "DDHPersonsListView.h"
#import "DDHBirthday.h"
#import "DDHPersonCell.h"
#import "NSArray+Functions.h"

@interface DDHPersonsListViewController ()
@property (nonatomic, strong) id<DDHPersonsListViewControllerProtocol> delegate;
@property (nonatomic, strong) DDHPersonsListView *contentView;
@property (nonatomic, strong) NSArray<DDHBirthday *> *birthdays;
@property (nonatomic, strong) UITableViewDiffableDataSource *dataSource;
@property (nonatomic, strong) NSPersonNameComponentsFormatter *nameFormatter;
@end

@implementation DDHPersonsListViewController

- (instancetype)initWithDelegate:(id<DDHPersonsListViewControllerProtocol>)delegate birthdays:(NSArray<DDHBirthday *> *)birthdays {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _delegate = delegate;
        _birthdays = birthdays;

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

    [self.tableView registerClass:[DDHPersonCell class] forCellReuseIdentifier:[DDHPersonCell identifier]];

    _dataSource = [[UITableViewDiffableDataSource alloc] initWithTableView:self.tableView cellProvider:^UITableViewCell * _Nullable(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {

        DDHPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:[DDHPersonCell identifier] forIndexPath:indexPath];

        NSUInteger index = [self.birthdays indexOfObjectPassingTest:^BOOL(DDHBirthday * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return (obj.uuid == itemIdentifier);
        }];

        DDHBirthday *birthday = self.birthdays[index];

        [cell updateWithBirthday:birthday nameFormatter:self.nameFormatter];

        return cell;
    }];

    [self updateWithBirthdays:self.birthdays];
}

- (void)updateWithBirthdays:(NSArray<DDHBirthday *> *)birthdays {
    NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
    [snapshot appendSectionsWithIdentifiers:@[@"Main"]];
    NSArray<NSUUID *> *uuids = [birthdays map:^id _Nonnull(DDHBirthday * _Nonnull input) {
        return input.uuid;
    }];
    [snapshot appendItemsWithIdentifiers:uuids];
    [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
}

@end
