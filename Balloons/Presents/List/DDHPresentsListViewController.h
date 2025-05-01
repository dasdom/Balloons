//  Created by Dominik Hauser on 25.04.25.
//  
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHBirthday;
@class DDHStorage;

@protocol DDHPresentsListViewControllerProtocol <NSObject>
- (void)viewControllerDidCancel:(UIViewController *)viewController;
- (void)viewControllerDidSelectAdd:(UIViewController *)viewController;
@end

@interface DDHPresentsListViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHPresentsListViewControllerProtocol>)delegate birthday:(DDHBirthday *)birthday storage:(DDHStorage *)storage;
@end

NS_ASSUME_NONNULL_END
