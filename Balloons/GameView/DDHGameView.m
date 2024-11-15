//  Created by Dominik Hauser on 15.11.24.
//  
//


#import "DDHGameView.h"

@implementation DDHGameView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _skView = [[SKView alloc] initWithFrame:frame];
        _skView.translatesAutoresizingMaskIntoConstraints = NO;

        UIButtonConfiguration *buttonConfig = [UIButtonConfiguration plainButtonConfiguration];
        buttonConfig.image = [UIImage systemImageNamed:@"plus"];
        _addButton = [UIButton buttonWithConfiguration:buttonConfig primaryAction:nil];

        buttonConfig.image = [UIImage systemImageNamed:@"gearshape"];
        _settingsButton = [UIButton buttonWithConfiguration:buttonConfig primaryAction:nil];

        UIStackView *buttonStackView = [[UIStackView alloc] initWithArrangedSubviews:@[_settingsButton, _addButton]];
        buttonStackView.translatesAutoresizingMaskIntoConstraints = NO;
        buttonStackView.spacing = 8;

        [self addSubview:_skView];
        [self addSubview:buttonStackView];

        [NSLayoutConstraint activateConstraints:@[
            [_skView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [_skView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [_skView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
            [_skView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],

            [buttonStackView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:16],
            [buttonStackView.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-16],
        ]];

    }
    return self;
}

@end
