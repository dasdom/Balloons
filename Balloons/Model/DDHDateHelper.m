//  Created by Dominik Hauser on 05.05.24.
//  
//


#import "DDHDateHelper.h"
#import "DDHDisplayMonth.h"

@implementation DDHDateHelper
+ (NSCalendar *)calendar {
    return NSCalendar.currentCalendar;
}

+ (NSInteger)daysLeftForDateComponents:(NSDateComponents *)components {
    NSDate *dateOfStartOfToday = [self.calendar startOfDayForDate:[NSDate now]];
    components.year = NSDateComponentUndefined;
    
    NSDate *nextBirthday = [self.calendar nextDateAfterDate:dateOfStartOfToday matchingComponents:components options:NSCalendarMatchNextTimePreservingSmallerUnits];
    NSInteger daysLeft = [self.calendar components:NSCalendarUnitDay fromDate:dateOfStartOfToday toDate:nextBirthday options:0].day;
    
    unsigned unitFlags = NSCalendarUnitCalendar | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *todayComponents = [self.calendar components:unitFlags fromDate:dateOfStartOfToday];
    NSDateComponents *nextBirthdayComponents = [self.calendar components:unitFlags fromDate:nextBirthday];
    
    if ([todayComponents isEqual:nextBirthdayComponents]) {
        return 0;
    }
    
    return daysLeft;
}

+ (NSInteger)daysLeftForDate:(NSDate *)date {
    NSDateComponents *components = [self dateComponentsForDate:date];
    return [self daysLeftForDateComponents:components];
}

+ (NSDateComponents *)dateComponentsForDate:(NSDate *)date {
    return [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
}

+ (NSInteger)ageForDateComponents:(NSDate *)date {
    NSDateComponents *ageComponents = [self.calendar components:NSCalendarUnitYear fromDate:date toDate:[NSDate now] options:NSCalendarMatchPreviousTimePreservingSmallerUnits];
    return ageComponents.year;
}

+ (NSArray<DDHDisplayMonth *> *)displayMonthsUseVeryShort:(BOOL)veryShort {
    NSDate *dateOfStartOfToday = [self.calendar startOfDayForDate:[NSDate now]];
    
    unsigned unitFlags = NSCalendarUnitMonth;
    
    NSDateComponents *dateComponents = [[self calendar] components:unitFlags fromDate:dateOfStartOfToday];
    NSMutableArray<DDHDisplayMonth *> *sceneMonths = [[NSMutableArray alloc] init];
    
    NSInteger startMonth = dateComponents.month-1;
    for (NSInteger i = 0; i < 12; i++) {
        dateComponents.month = (startMonth + i) % 12 + 1;
        NSLog(@"month: %ld", dateComponents.month);
        NSDate *startOfNextMonthDate = [[self calendar] nextDateAfterDate:dateOfStartOfToday matchingComponents:dateComponents options:NSCalendarMatchNextTimePreservingSmallerUnits];
        
        NSInteger start = [self.calendar components:NSCalendarUnitDay fromDate:dateOfStartOfToday toDate:startOfNextMonthDate options:0].day;
        if (sceneMonths.count == 0) {
            start = start - 365;
        }
        NSLog(@"start: %ld", start);
        
        NSString *name;
        if (veryShort) {
            name = [self calendar].veryShortMonthSymbols[(dateComponents.month - 1) % 12];
        } else {
            name = [self calendar].shortMonthSymbols[(dateComponents.month - 1) % 12];
        }
        NSLog(@"name: %@", name);
        
        dateComponents.month = (startMonth + i + 1) % 12 + 1;
        NSDate *endOfNextMonth = [[self calendar] nextDateAfterDate:dateOfStartOfToday matchingComponents:dateComponents options:NSCalendarMatchNextTimePreservingSmallerUnits];
        
        NSInteger end = [self.calendar components:NSCalendarUnitDay fromDate:dateOfStartOfToday toDate:endOfNextMonth options:0].day - 1;
        NSLog(@"end: %ld", end);
        NSLog(@"--");
        //    NSLog(@"number of days: %ld", end - start);
        
        DDHDisplayMonth *sceneMonth = [[DDHDisplayMonth alloc] initWithName:name start:start end:end];
        [sceneMonths addObject:sceneMonth];
    }
    return sceneMonths;
}

@end
