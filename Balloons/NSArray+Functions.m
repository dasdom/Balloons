//  Created by Dominik Hauser on 25.01.25.
//  
//


#import "NSArray+Functions.h"

@implementation NSArray (Functions)
- (NSArray *)map:(id(^)(id))mapBlock {
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for (id input in self) {
        id output = mapBlock(input);
        [tempArray addObject:output];
    }
    return [tempArray copy];
}

- (NSArray *)filter:(BOOL(^)(id))filterBlock {
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for (id input in self) {
        if (filterBlock(input)) {
            [tempArray addObject:input];
        }
    }
    return tempArray;
}

- (id)firstObjectPassingTest:(BOOL (NS_NOESCAPE ^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    NSInteger index = [self indexOfObjectPassingTest:predicate];
    if (index == NSNotFound) {
        return nil;
    }
    return self[index];
}
@end
