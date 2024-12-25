//  Created by Dominik Hauser on 22.12.24.
//  
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DDHBirthdayInputViewControllerProtocol <NSObject>
- (void)didSelectImportFromContactsInViewController:(UIViewController *)viewController;
- (void)didSelectPhotoInViewController:(UIViewController *)viewController;
- (void)didSelectCancelInViewController:(UIViewController *)viewController;
@end

@interface DDHBirthdayInputViewController : UIViewController
- (instancetype)initWithDelegate:(id<DDHBirthdayInputViewControllerProtocol>)delegate;
- (void)setImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
