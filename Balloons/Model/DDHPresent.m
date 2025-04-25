//  Created by Dominik Hauser on 23.04.25.
//  
//


#import "DDHPresent.h"

@implementation DDHPresent
- (instancetype)initWithUUID:(NSUUID *)uuid birthdayUUID:(NSUUID *)birthdayUUID url:(NSURL *)url title:(NSString *)title givenAway:(BOOL)givenAway priority:(NSInteger)priority note:(NSString *)note {
    if (self = [super init]) {
        _uuid = uuid;
        _birthdayUUID = birthdayUUID;
        _url = url;
        _title = title;
        _givenAway = givenAway;
        _priority = priority;
        _note = note;
    }
    return self;
}
@end
