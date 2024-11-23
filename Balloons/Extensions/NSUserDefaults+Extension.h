//  Created by Dominik Hauser on 22.11.24.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (Extension)
- (void)setup;
- (NSInteger)numberOfShownDays;
- (void)setNumberOfShownDays:(NSInteger)numberOfShownDays;
- (BOOL)notificationsActive;
- (void)setNotificationsActive:(BOOL)notificationsActive;
@end

NS_ASSUME_NONNULL_END
