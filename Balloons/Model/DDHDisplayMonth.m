//  Created by Dominik Hauser on 10.05.24.
//  
//


#import "DDHDisplayMonth.h"

@implementation DDHDisplayMonth
- (instancetype)initWithName:(NSString *)name start:(NSInteger)start end:(NSInteger)end {
    if (self = [super init]) {
        _name = name;
        _start = start;
        _end = end;
    }
    return self;
}
@end
