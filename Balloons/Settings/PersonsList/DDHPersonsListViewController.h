//  Created by Dominik Hauser on 24.01.25.
//  
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHBirthday;

@protocol DDHPersonsListViewControllerProtocol <NSObject>

@end

@interface DDHPersonsListViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHPersonsListViewControllerProtocol>)delegate birthdays:(NSArray<DDHBirthday *> *)birthdays;
@end

NS_ASSUME_NONNULL_END
