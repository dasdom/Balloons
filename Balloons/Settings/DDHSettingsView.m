//  Created by Dominik Hauser on 17.11.24.
//  
//


#import "DDHSettingsView.h"

@implementation DDHSettingsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _daysSegmentedControl = [[UISegmentedControl alloc] init];
        _daysSegmentedControl.selectedSegmentIndex = 2;
        _daysSegmentedControl.selectedSegmentTintColor = [UIColor systemOrangeColor];
        [_daysSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor systemOrangeColor]} forState:UIControlStateNormal];
        [_daysSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateSelected];
        _daysSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];

        [self addSubview:_daysSegmentedControl];

        [NSLayoutConstraint activateConstraints:@[
            [_daysSegmentedControl.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:20],
            [_daysSegmentedControl.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor constant:20],
            [_daysSegmentedControl.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-20],
        ]];
    }
    return self;
}

@end
