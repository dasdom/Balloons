//  Created by Dominik Hauser on 22.11.24.
//  
//


#import "NSUserDefaults+Extension.h"
#import "DDHNumberOfShownDays.h"

NSString * const numberOfShownDaysKey = @"de.dasdom.numberOfShownDaysKey";
NSString * const notificationsActiveKey = @"de.dasdom.notificationsKey";

@implementation NSUserDefaults (Extension)

- (void)setup {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{numberOfShownDaysKey: @(DDHNumberOfShownDaysTwoHundredEighty)}];
}

- (NSInteger)numberOfShownDays {
    return [self integerForKey:numberOfShownDaysKey];
}

- (void)setNumberOfShownDays:(NSInteger)numberOfShownDays {
    [self setInteger:numberOfShownDays forKey:numberOfShownDaysKey];
}

- (BOOL)notificationsActive {
    return [self boolForKey:notificationsActiveKey];
}

- (void)setNotificationsActive:(BOOL)notificationsActive {
    [self setBool:notificationsActive forKey:notificationsActiveKey];
}

@end
