//  Created by Dominik Hauser on 22.11.24.
//  
//


#import "NSUserDefaults+Extension.h"
#import "DDHNumberOfShownDays.h"

NSString * const numberOfShownDaysKey = @"de.dasdom.numberOfShownDaysKey";

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

@end
