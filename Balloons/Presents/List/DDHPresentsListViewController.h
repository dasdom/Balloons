//  Created by Dominik Hauser on 25.04.25.
//  
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHBirthday;
@class DDHStorage;

@protocol DDHPresentsListViewControllerProtocol <NSObject>
- (void)viewControllerDidDone:(UIViewController *)viewController;
- (void)viewControllerDidSelectAdd:(UIViewController *)viewController birthday:(DDHBirthday *)birthday storage:(DDHStorage *)storage;
@end

@interface DDHPresentsListViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHPresentsListViewControllerProtocol>)delegate birthday:(DDHBirthday *)birthday storage:(DDHStorage *)storage;
- (void)loadAndUpdate;
@end

NS_ASSUME_NONNULL_END
