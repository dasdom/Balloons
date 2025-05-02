//  Created by Dominik Hauser on 27.04.25.
//  
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DDHPresentInputViewControllerProtocol <NSObject>
- (void)viewControllerDidDone:(UIViewController *)viewController;
- (void)viewControllerDidAddPresent:(UIViewController *)viewController;
@end

@class DDHBirthday;
@class DDHStorage;

@interface DDHPresentInputViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHPresentInputViewControllerProtocol>)delegate birthday:(DDHBirthday *)birthday storage:(DDHStorage *)storage;
@end

NS_ASSUME_NONNULL_END
