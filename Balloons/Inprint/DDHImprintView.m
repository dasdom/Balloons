//  Created by Dominik Hauser on 01.01.25.
//  
//


#import "DDHImprintView.h"
#import "DDHCaveScene.h"

@interface DDHImprintView ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) DDHCaveScene *caveScene;
@property (nonatomic, strong) SKView *gameView;
@end

@implementation DDHImprintView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        CGRect gameFrame = CGRectMake(0, 0, screenBounds.size.width, 200);
        _caveScene = [[DDHCaveScene alloc] initWithSize:gameFrame.size];
        _caveScene.scaleMode = SKSceneScaleModeAspectFill;
        _caveScene.anchorPoint = CGPointMake(0.5, 0.5);

        _gameView = [[SKView alloc] initWithFrame:gameFrame];
        _gameView.ignoresSiblingOrder = YES;
        [_gameView presentScene:_caveScene];

        _textView = [[UITextView alloc] init];
        _textView.editable = NO;
        _textView.selectable = NO;
        _textView.decelerationRate = UIScrollViewDecelerationRateFast;

        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_gameView, _textView]];
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.axis = UILayoutConstraintAxisVertical;

        self.backgroundColor = [UIColor systemBackgroundColor];

        [self addSubview:stackView];

        NSLayoutConstraint *gameViewHeightConstraint = [_gameView.heightAnchor constraintEqualToConstant:200];
        gameViewHeightConstraint.priority = 999;

        [NSLayoutConstraint activateConstraints:@[
            [stackView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor],
            [stackView.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor],
            [stackView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor],
            [stackView.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor],

            gameViewHeightConstraint,
        ]];
    }
    return self;
}
@end
