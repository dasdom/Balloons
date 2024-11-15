//  Created by Dominik Hauser on 04.05.24.
//
//


#import "DDHBirthday.h"
#import <Contacts/Contacts.h>
#import "DDHDateHelper.h"
#import "NSFileManager+Extension.h"

@implementation DDHBirthday
- (instancetype)initWithUUID:(NSUUID *)uuid date:(NSDate *)date personNameComponents:(NSPersonNameComponents *)personNameComponents {
    if (self = [super init]) {
        _uuid = uuid;
        _imageData = [self imageDataForPersonUUID:uuid];
        _daysLeft = [DDHDateHelper daysLeftForDate:date];
        _date = date;
        _personNameComponents = personNameComponents;
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

- (Boolean)yearUnknown {
    if ([[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:self.date] == 1064) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)description {
    return [@[self.uuid.UUIDString, [NSString stringWithFormat:@"%ld", self.daysLeft], self.personNameComponents.givenName] componentsJoinedByString:@", "];
}



@end
