//  Created by Dominik Hauser on 22.11.24.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (Extension)
- (NSInteger)numberOfShownDays;
- (void)setNumberOfShownDays:(NSInteger)numberOfShownDays;
@end

NS_ASSUME_NONNULL_END
