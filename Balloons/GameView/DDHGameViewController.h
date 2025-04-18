//  Created by Dominik Hauser on 27.10.24.
//  
//


#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@class DDHBirthday;
@class DDHStorage;

@protocol DDHGameViewControllerDelegate <NSObject>
- (void)didSelectInfo:(UIViewController *)viewController;
- (void)didSelectSettings:(UIViewController *)viewController storage:(DDHStorage *)storage;
- (void)didSelectAdd:(UIViewController *)viewController;
@end

@interface DDHGameViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHGameViewControllerDelegate>)delegate;
- (void)pointGravityDown;
- (void)pointGravityUp;
- (void)setNumberOfShownDays:(NSInteger)numberOfShownDays;
- (void)updateWithBirthdays:(NSArray<DDHBirthday *> *)birthdays;
- (void)addBirthday:(DDHBirthday *)birthday;
@end
