//  Created by Dominik Hauser on 04.05.24.
//
//


#import "DDHBirthday.h"
#import <Contacts/Contacts.h>
#import "DDHDateHelper.h"

@implementation DDHBirthday
- (instancetype)initWithUUID:(NSUUID *)uuid imageData:(NSData *)imageData daysLeft:(NSInteger)daysLeft date:(NSDate *)date personNameComponents:(NSPersonNameComponents *)personNameComponents {
    if (self = [super init]) {
        _uuid = uuid;
        _imageData = imageData;
        _daysLeft = daysLeft;
        _date = date;
        _personNameComponents = personNameComponents;
    }
    return self;
}

- (instancetype)initWithContact:(CNContact *)contact {
    if (self = [super init]) {
        _uuid = [[NSUUID alloc] initWithUUIDString:contact.identifier];
        _imageData = contact.thumbnailImageData;
        _daysLeft = [DDHDateHelper daysLeftForDateComponents:contact.birthday];
        _date = [NSCalendar.currentCalendar dateFromComponents:contact.birthday];

        NSPersonNameComponents *personNameComponents = [[NSPersonNameComponents alloc] init];
        personNameComponents.familyName = contact.familyName;
        personNameComponents.givenName = contact.givenName;
        _personNameComponents = personNameComponents;
    }
    return self;
}

- (Boolean)yearUnknown {
    if ([[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:self.date] == 1064) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)description {
    return [@[self.uuid.UUIDString, [NSString stringWithFormat:@"%ld", self.daysLeft], self.personNameComponents.givenName, self.personNameComponents.familyName] componentsJoinedByString:@", "];
}
@end
