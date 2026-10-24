//  Created by Dominik Hauser on 04.03.26.
//  
//


#import "DDHEvent.h"
#import "DDHDateHelper.h"
#import <UserNotifications/UserNotifications.h>

@implementation DDHEvent
- (instancetype)initWithUUID:(NSUUID *)uuid date:(NSDate *)date emoji:(NSString *)emoji name:(NSString *)name favorite:(BOOL)favorite {
    if (self = [super init]) {
        _uuid = uuid;
        _date = date;
        _daysLeft = [DDHDateHelper daysLeftForDate:date];
        _emoji = emoji;
        _name = name;
        _favorite = favorite;
    }
    return self;
}

- (void)updateDaysLeft {
    self.daysLeft = [DDHDateHelper daysLeftForDate:self.date];
}

- (NSString *)balloonText {
    return self.emoji;
}

- (NSString *)detailStringWithNameFormatter:(NSPersonNameComponentsFormatter *)nameFormatter dateFormatterWithYear:(NSDateFormatter *)dateFormatterWithYear dateFormatterWithoutYear:(NSDateFormatter *)dateFormatterWithoutYear {
    NSString *detailString;
    NSString *dateString = [dateFormatterWithYear stringFromDate:self.date];
    NSInteger age = [DDHDateHelper ageForDateComponents:self.date];
    if (self.daysLeft > 0) {
        age = age + 1;
    }
    detailString = [NSString stringWithFormat:@"%@\n%@\nin %ld days",
                    self.name,
                    dateString,
                    self.daysLeft
    ];
    return detailString;
}

- (UNNotificationRequest *)notificationRequest {
    NSCalendar * calendar = NSCalendar.currentCalendar;

    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"%@" arguments:@[self.name]];
    content.body = [NSString localizedUserNotificationStringForKey:@"%@s is in 7 days!"
                                                         arguments:@[self.name]];
    content.sound = [UNNotificationSound defaultSound];

    NSDate *notificationDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:-7 toDate:self.date options:0];

    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:notificationDate];
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:YES];

    return [UNNotificationRequest requestWithIdentifier:self.uuid.UUIDString content:content trigger:trigger];
}

@end
