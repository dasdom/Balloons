//  Created by Dominik Hauser on 22.12.24.
//  
//


#import <UIKit/UIKit.h>
#import "DDHInputType.h"
#import "DDHEmojiTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDHBirthdayInputView : UIView
@property (nonatomic, strong) UIButton *importButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) DDHEmojiTextField *emojiTextField;
@property (nonatomic, strong) UITextField *givenNameTextField;
@property (nonatomic, strong) UITextField *familyNameTextField;
@property (nonatomic, strong) UIDatePicker *birthdayPicker;
@property (nonatomic, strong) UIButton *addButton;
- (void)updateWithInputType:(DDHInputType)inputType;
@end

NS_ASSUME_NONNULL_END
