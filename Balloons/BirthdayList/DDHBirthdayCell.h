//  Created by Dominik Hauser on 15.01.25.
//  
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHBirthday;

@interface DDHBirthdayCell : UICollectionViewCell
- (void)updateWithBirthdays:(NSArray<DDHBirthday *> *)birthdays dateFormatter:(NSDateFormatter *)dateFormatter date:(NSDate *)date daysLeft:(NSInteger)daysLeft;
@end

NS_ASSUME_NONNULL_END
