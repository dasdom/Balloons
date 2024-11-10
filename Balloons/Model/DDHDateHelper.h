//  Created by Dominik Hauser on 05.05.24.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHDisplayMonth;

@interface DDHDateHelper : NSObject
+ (NSInteger)daysLeftForDateComponents:(NSDateComponents *)components;
+ (NSArray<DDHDisplayMonth *> *)displayMonthsUseVeryShort:(BOOL)veryShort;
+ (NSInteger)ageForDateComponents:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
