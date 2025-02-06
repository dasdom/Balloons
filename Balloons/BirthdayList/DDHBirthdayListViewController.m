//  Created by Dominik Hauser on 15.01.25.
//  
//


#import "DDHBirthdayListViewController.h"
#import "DDHBirthdayListView.h"
#import "DDHBirthdayCell.h"
#import "DDHStorage.h"
#import "DDHBirthday.h"
#import "DDHBirthdayListSectionHeaderView.h"

@interface DDHBirthdayListViewController () <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) DDHBirthdayListView *contentView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSDictionary<NSNumber *, NSArray<DDHBirthday *> *> *birthdaysForDaysLeft;
@property (nonatomic, strong) UICollectionViewDiffableDataSource *dataSource;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (assign) BOOL filtered;
@end

@implementation DDHBirthdayListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _dateFormatter = [[NSDateFormatter alloc] init];
//        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
//        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.dateFormat = @"dd";
    }
    return self;
}

- (DDHBirthdayListView *)contentView {
    return (DDHBirthdayListView *)self.view;
}

- (UICollectionView *)collectionView {
    return self.contentView.collectionView;
}

- (void)loadView {
    self.view = [[DDHBirthdayListView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"line.3.horizontal.decrease.circle"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleFilter:)];
    self.navigationItem.leftBarButtonItem = filterButton;

    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[DDHBirthdayCell class] configurationHandler:^(__kindof DDHBirthdayCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSNumber *  _Nonnull item) {
        NSArray<DDHBirthday *> *birthdays = self.birthdaysForDaysLeft[item];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger daysLeft = [item integerValue];
        NSDate *date = [calendar dateByAddingUnit:NSCalendarUnitDay value:daysLeft toDate:[NSDate date] options:0];
        [cell updateWithBirthdays:birthdays dateFormatter:self.dateFormatter date:date daysLeft:daysLeft];
    }];

    UICollectionViewSupplementaryRegistration *headerRegistration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:[DDHBirthdayListSectionHeaderView class] elementKind:UICollectionElementKindSectionHeader configurationHandler:^(__kindof DDHBirthdayListSectionHeaderView * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        NSString *sectionIdentifier = [self.dataSource sectionIdentifierForIndex:indexPath.section];
        [supplementaryView updateWithName:sectionIdentifier];
    }];

    _dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, NSNumber *  _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
    }];

    _dataSource.supplementaryViewProvider = ^UICollectionReusableView * _Nullable(UICollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:headerRegistration forIndexPath:indexPath];
    };

    self.collectionView.delegate = self;

    NSDictionary<NSNumber *, NSArray<DDHBirthday *> *> *birthdaysForDaysLeft = [self loadBirthdays];
    [self updateWithBirthdaysForDaysLeft:birthdaysForDaysLeft];
}

- (NSDictionary<NSNumber *, NSArray<DDHBirthday *> *> *)loadBirthdays {
    DDHStorage *storage = [[DDHStorage alloc] init];

    NSArray *birthdays = [[storage birthdays] sortedArrayUsingComparator:^NSComparisonResult(DDHBirthday *  _Nonnull obj1, DDHBirthday *  _Nonnull obj2) {
        if (obj1.daysLeft < obj2.daysLeft) {
            return NSOrderedAscending;
        } else if (obj1.daysLeft > obj2.daysLeft) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];

    NSMutableDictionary<NSNumber *, NSArray<DDHBirthday *> *> *birthdaysForDaysLeft = [[NSMutableDictionary alloc] initWithCapacity:[birthdays count]];
    for (DDHBirthday *birthday in birthdays) {
        NSNumber *numberOfDaysLeft = @(birthday.daysLeft);
        NSMutableArray<DDHBirthday *> *birthdaysGroup = [birthdaysForDaysLeft[numberOfDaysLeft] mutableCopy];
        if (nil == birthdaysGroup) {
            birthdaysGroup = [[NSMutableArray alloc] init];
        }
        [birthdaysGroup addObject:birthday];
        birthdaysForDaysLeft[numberOfDaysLeft] = birthdaysGroup;
    }
    return birthdaysForDaysLeft;
}

- (void)updateWithBirthdaysForDaysLeft:(NSDictionary<NSNumber *, NSArray<DDHBirthday *> *> *)birthdaysForDaysLeft {
    self.birthdaysForDaysLeft = birthdaysForDaysLeft;

    NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *previousDateComponents = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];

    NSMutableArray<NSNumber *> *daysLeftUntilInOneYear = [[NSMutableArray alloc] init];
    NSString *sectionIdentifier;
    NSDateComponents *dateComponents;
    for (NSUInteger i=0; i<366; i++) {
        if (self.filtered && [self.birthdaysForDaysLeft[@(i)] count] < 1) {
            continue;
        }
        NSDate *date = [calendar dateByAddingUnit:NSCalendarUnitDay value:i toDate:[NSDate date] options:0];
        dateComponents = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
        if (previousDateComponents.month != dateComponents.month) {
            NSInteger monthIndex = previousDateComponents.month - 1;
            if (monthIndex < 0) {
                monthIndex = calendar.monthSymbols.count - 1;
            }
            NSString *monthName = calendar.monthSymbols[monthIndex];
            sectionIdentifier = [NSString stringWithFormat:@"%@ %ld", monthName, (long)previousDateComponents.year];
            [snapshot appendSectionsWithIdentifiers:@[sectionIdentifier]];
            [snapshot appendItemsWithIdentifiers:daysLeftUntilInOneYear intoSectionWithIdentifier:sectionIdentifier];
            daysLeftUntilInOneYear = [[NSMutableArray alloc] init];
            previousDateComponents = dateComponents;
        }

        [daysLeftUntilInOneYear addObject:@(i)];
    }

    NSString *monthName = calendar.monthSymbols[previousDateComponents.month-1];
    sectionIdentifier = [NSString stringWithFormat:@"%@ %ld", monthName, (long)previousDateComponents.year];
    [snapshot appendSectionsWithIdentifiers:@[sectionIdentifier]];
    [snapshot appendItemsWithIdentifiers:daysLeftUntilInOneYear intoSectionWithIdentifier:sectionIdentifier];

//    for (NSNumber *daysLeft in birthdaysForDaysLeft) {
//        [daysLeftUntilInOneYear addObject:daysLeft];
//    }

    [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.contentView.frame.size.width, 40);
}

- (void)toggleFilter:(UIBarButtonItem *)sender {
    self.filtered = !self.filtered;
    [self updateWithBirthdaysForDaysLeft:self.birthdaysForDaysLeft];
}
@end
