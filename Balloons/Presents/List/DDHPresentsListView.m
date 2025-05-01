//  Created by Dominik Hauser on 25.04.25.
//  
//


#import "DDHPresentsListView.h"

@implementation DDHPresentsListView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _tableView = [[UITableView alloc] init];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;

        self.backgroundColor = [UIColor systemBackgroundColor];
        
        [self addSubview:_tableView];

        [NSLayoutConstraint activateConstraints:@[
            [_tableView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor],
            [_tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [_tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
            [_tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        ]];
    }
    return self;
}
@end
