//  Created by Dominik Hauser on 15.01.25.
//  
//


#import "DDHBirthdayListView.h"

@implementation DDHBirthdayListView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[self layout]];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:_collectionView];

        [NSLayoutConstraint activateConstraints:@[
            [_collectionView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [_collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [_collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
            [_collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        ]];
    }
    return self;
}

- (UICollectionViewLayout *)layout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.headerReferenceSize = CGSizeMake(200, 30);
    layout.sectionHeadersPinToVisibleBounds = YES;
    layout.minimumLineSpacing = 0;
    return layout;
}
@end
