//  Created by Dominik Hauser on 10.03.26.
//  
//


#import "DDHEmojiTextField.h"

@implementation DDHEmojiTextField

- (UITextInputMode *)textInputMode {
    for (UITextInputMode *inputMode in UITextInputMode.activeInputModes) {
        if ([inputMode.primaryLanguage isEqualToString:@"emoji"]) {
            return inputMode;
        }
    }
    return nil;
}

@end
