//  Created by Dominik Hauser on 25.01.25.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Functions)
- (NSArray *)map:(id(^)(id))mapBlock;
- (NSArray *)filter:(BOOL(^)(id))filterBlock;
- (id)firstObjectPassingTest:(BOOL (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))predicate;
@end

NS_ASSUME_NONNULL_END
