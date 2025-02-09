//  Created by Dominik Hauser on 17.11.24.
//  
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHBirthday;
@class DDHStorage;

@protocol DDHSettingsViewControllerDelegate <NSObject>
- (void)didChangeNumberOfShownDays:(UIViewController *)viewController numberOfShownDays:(NSInteger)numberOfShownDays;
- (void)didSelectCloseInViewController:(UIViewController *)viewController;
- (void)didSelectPersonsInViewController:(UIViewController *)viewController storage:(DDHStorage *)storage;
@end

@interface DDHSettingsViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHSettingsViewControllerDelegate>)delegate storage:(DDHStorage *)storage;
@end

NS_ASSUME_NONNULL_END
