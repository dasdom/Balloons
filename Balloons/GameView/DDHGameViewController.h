//  Created by Dominik Hauser on 27.10.24.
//  
//


#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@protocol DDHGameViewControllerDelegate <NSObject>
- (void)didSelectSettingsInViewController:(UIViewController *)viewController;
@end

@interface DDHGameViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHGameViewControllerDelegate>)delegate;
- (void)pointGravityDown;
- (void)pointGravityUp;
- (void)setNumberOfShownDays:(NSInteger)numberOfShownDays;
@end
