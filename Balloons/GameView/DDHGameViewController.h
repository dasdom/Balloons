//  Created by Dominik Hauser on 27.10.24.
//  
//


#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@class DDHBirthday;

@protocol DDHGameViewControllerDelegate <NSObject>
- (void)didSelectSettingsInViewController:(UIViewController *)viewController birthdays:(NSArray<DDHBirthday *> *)birthdays;
@end

@interface DDHGameViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHGameViewControllerDelegate>)delegate;
- (void)pointGravityDown;
- (void)pointGravityUp;
- (void)setNumberOfShownDays:(NSInteger)numberOfShownDays;
@end
