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
@end
