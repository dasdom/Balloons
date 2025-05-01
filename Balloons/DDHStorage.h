//  Created by Dominik Hauser on 12.11.24.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHBirthday;
@class DDHPresent;

@interface DDHStorage : NSObject
- (void)createDatabaseIfNeeded;
- (BOOL)insertBirthdays:(NSArray<DDHBirthday *> *)birthdays;
- (BOOL)insertBirthday:(DDHBirthday *)birthday;
- (BOOL)updateFavorite:(BOOL)favorite forBirthday:(DDHBirthday *)birthday;
- (BOOL)deleteBirthday:(DDHBirthday *)birthday;
- (NSArray<DDHBirthday *> *)birthdays;

- (void)createPresentsDatabaseIfNeeded;
- (BOOL)insertPresent:(DDHPresent *)present;
- (BOOL)updateGivenAwayDate:(NSDate *)givenAwayDate forPresent:(DDHPresent *)present;
- (BOOL)deletePresent:(DDHPresent *)present;
- (NSArray<DDHPresent *> *)presentsForBirthday:(DDHBirthday *)birthday;

@end

NS_ASSUME_NONNULL_END
