//  Created by Dominik Hauser on 22.12.24.
//  
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHBirthdayInputView : UIView
@property (nonatomic, strong) UIButton *importButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *givenNameTextField;
@property (nonatomic, strong) UITextField *familyNameTextField;
@property (nonatomic, strong) UIDatePicker *birthdayPicker;
@property (nonatomic, strong) UIButton *addButton;
@end

NS_ASSUME_NONNULL_END
