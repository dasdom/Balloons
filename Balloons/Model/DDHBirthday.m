//  Created by Dominik Hauser on 04.05.24.
//
//


#import "DDHBirthday.h"
#import <Contacts/Contacts.h>
#import "DDHDateHelper.h"
#import "NSFileManager+Extension.h"
#import <UserNotifications/UserNotifications.h>

@implementation DDHBirthday
- (instancetype)initWithUUID:(NSUUID *)uuid date:(NSDate *)date personNameComponents:(NSPersonNameComponents *)personNameComponents yearUnknown:(BOOL)yearUnknown {
    if (self = [super init]) {
        _uuid = uuid;
        _imageData = [self imageDataForPersonUUID:uuid];
        _daysLeft = [DDHDateHelper daysLeftForDate:date];
        _date = date;
        _personNameComponents = personNameComponents;
        _yearUnknown = yearUnknown;
    }
    return self;
}

- (instancetype)initWithContact:(CNContact *)contact {
    if (self = [super init]) {
        NSArray<NSString *> *components = [contact.identifier componentsSeparatedByString:@":"];
        if (components.firstObject.length < 1) {
            _uuid = [NSUUID UUID];
        } else {
            _uuid = [[NSUUID alloc] initWithUUIDString:components.firstObject];
        }

        _imageData = contact.thumbnailImageData;
        [self saveImageData:_imageData personUUID:_uuid];

        if (contact.birthday.year > 100000) {
            _yearUnknown = YES;
        } else {
            _yearUnknown = NO;
        }

        _daysLeft = [DDHDateHelper daysLeftForDateComponents:contact.birthday];
        _date = [NSCalendar.currentCalendar dateFromComponents:contact.birthday];

        NSPersonNameComponents *personNameComponents = [[NSPersonNameComponents alloc] init];
        personNameComponents.familyName = contact.familyName;
        personNameComponents.givenName = contact.givenName;
        _personNameComponents = personNameComponents;
    }
    return self;
}

- (void)saveImageData:(NSData *)imageData personUUID:(NSUUID *)uuid {
    NSURL *imageURL = [[NSFileManager defaultManager] imageURLWithPersonUUID:uuid];
    NSError *error;
    [imageData writeToFile:[imageURL path] options:0 error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
}

- (NSData *)imageDataForPersonUUID:(NSUUID *)uuid {
    NSURL *imageURL = [[NSFileManager defaultManager] imageURLWithPersonUUID:uuid];
    return [NSData dataWithContentsOfFile:[imageURL path]];
}

- (void)updateDaysLeft {
    self.daysLeft = [DDHDateHelper daysLeftForDate:self.date];
}

- (UNNotificationRequest *)notificationRequest {
    NSCalendar * calendar = NSCalendar.currentCalendar;

    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:@"%@s birthday" arguments:@[self.personNameComponents.givenName]];
    content.body = [NSString localizedUserNotificationStringForKey:@"%@s birthday is in 7 days!"
                                                         arguments:@[self.personNameComponents.givenName]];
    content.sound = [UNNotificationSound defaultSound];

    NSDate *notificationDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:-7 toDate:self.date options:0];

    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:notificationDate];
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:YES];

    return [UNNotificationRequest requestWithIdentifier:self.uuid.UUIDString content:content trigger:trigger];
}

- (NSString *)description {
    return [@[self.uuid.UUIDString, [NSString stringWithFormat:@"%ld", self.daysLeft], self.personNameComponents.givenName] componentsJoinedByString:@", "];
}

@end
