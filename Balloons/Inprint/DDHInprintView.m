//  Created by Dominik Hauser on 01.01.25.
//  
//


#import "DDHInprintView.h"
#import "DDHCaveScene.h"

@interface DDHInprintView ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) DDHCaveScene *caveScene;
@property (nonatomic, strong) SKView *gameView;
@end

@implementation DDHInprintView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        CGRect gameFrame = CGRectMake(0, 0, screenBounds.size.width, 400);
        _caveScene = [[DDHCaveScene alloc] initWithSize:gameFrame.size];
        _caveScene.scaleMode = SKSceneScaleModeAspectFill;
        _caveScene.anchorPoint = CGPointMake(0.5, 0.5);

        _gameView = [[SKView alloc] initWithFrame:gameFrame];
        _gameView.ignoresSiblingOrder = YES;

        _textView = [[UITextView alloc] init];
        _textView.editable = NO;
        _textView.selectable = NO;
        _textView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return self;
}
@end
