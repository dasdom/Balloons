//  Created by Dominik Hauser on 17.11.24.
//  
//


#import "DDHSettingsView.h"

@implementation DDHSettingsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _tableView = [[UITableView alloc] init];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.backgroundColor = [UIColor clearColor];

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];

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
