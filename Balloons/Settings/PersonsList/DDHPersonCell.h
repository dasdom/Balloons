//  Created by Dominik Hauser on 24.01.25.
//  
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHBirthday;

@interface DDHPersonCell : UITableViewCell
+ (NSString *)identifier;
- (void)updateWithBirthday:(DDHBirthday *)birthday nameFormatter:(NSPersonNameComponentsFormatter *)nameFormatter;
@end

NS_ASSUME_NONNULL_END
