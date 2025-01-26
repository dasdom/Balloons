//  Created by Dominik Hauser on 25.01.25.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Functions)
- (NSArray *)map:(id(^)(id))mapBlock;
@end

NS_ASSUME_NONNULL_END
