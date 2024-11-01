//  Created by Dominik Hauser on 05.05.24.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHSceneMonth;

@interface DDHDateHelper : NSObject
+ (NSInteger)daysLeftForDateComponents:(NSDateComponents *)components;
+ (NSArray<DDHSceneMonth *> *)sceneMonths;
@end

NS_ASSUME_NONNULL_END
