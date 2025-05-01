//  Created by Dominik Hauser on 27.04.25.
//  
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHPresent;

@interface DDHPresentCell : UITableViewCell
+ (NSString *)identifier;
- (void)updateWithPresent:(DDHPresent *)present;
@end

NS_ASSUME_NONNULL_END
