//  Created by Dominik Hauser on 12.11.24.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHBirthday;

@interface DDHStorage : NSObject
- (void)createDatabaseIfNeeded;
- (BOOL)insertBirthdays:(NSArray<DDHBirthday *> *)birthdays;
- (BOOL)insertBirthday:(DDHBirthday *)birthday;
- (BOOL)updateFavorite:(BOOL)favorite forBirthday:(DDHBirthday *)birthday;
- (BOOL)deleteBirthday:(DDHBirthday *)birthday;
- (NSArray<DDHBirthday *> *)birthdays;
@end

NS_ASSUME_NONNULL_END
