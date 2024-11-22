//  Created by Dominik Hauser on 17.11.24.
//  
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DDHSettingsViewControllerDelegate <NSObject>
- (void)didChangeNumberOfShownDays:(UIViewController *)viewController numberOfShownDays:(NSInteger)numberOfShownDays;
- (void)didSelectCloseInViewController:(UIViewController *)viewController;
@end

@interface DDHSettingsViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHSettingsViewControllerDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
