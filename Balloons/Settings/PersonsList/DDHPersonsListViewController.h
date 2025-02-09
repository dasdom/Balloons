//  Created by Dominik Hauser on 24.01.25.
//  
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHStorage;

@protocol DDHPersonsListViewControllerProtocol <NSObject>
- (void)reloadBirthdaysFromViewController:(UIViewController *)viewController;
@end

@interface DDHPersonsListViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHPersonsListViewControllerProtocol>)delegate storage:(DDHStorage *)storage;
@end

NS_ASSUME_NONNULL_END
