//  Created by Dominik Hauser on 05.05.24.
//
//


#import "DDHContactsManager.h"
#import <Contacts/Contacts.h>
#import "DDHBirthday.h"

@interface DDHContactsManager ()
@property (nonatomic, strong) CNContactStore *contactsStore;
@end

@implementation DDHContactsManager
- (instancetype)init {
    if (self = [super init]) {
        _contactsStore = [[CNContactStore alloc] init];
    }
    return self;
}

- (void)requestContactsAccess:(void(^)(BOOL granted))completionHandler {
    [self.contactsStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        completionHandler(granted);
    }];
}

- (BOOL)isAuthorised {
    return [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized;
}

- (void)fetchImportableContactsIgnoringExitingIds:(NSArray<NSString *> *)existingIds completionHandler:(void(^)(NSArray<CNContact *> *contacts))completionHandler {
    
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[
        CNContactGivenNameKey,
        CNContactFamilyNameKey,
        CNContactBirthdayKey,
        CNContactThumbnailImageDataKey
    ]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSError *fetchError;
        NSMutableArray<CNContact *> *contacts = [[NSMutableArray alloc] init];
        [self.contactsStore enumerateContactsWithFetchRequest:fetchRequest error:&fetchError usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            if (contact.birthday.date != nil &&
                NO == [existingIds containsObject:contact.identifier]) {
                [contacts addObject:contact];
            }
        }];
        completionHandler(contacts);
    });
}

- (NSArray<DDHBirthday *> *)birthdaysFromContacts:(NSArray<CNContact *> *)contacts {
    NSMutableArray<DDHBirthday *> *birthdays = [NSMutableArray arrayWithCapacity:[contacts count]];

    for (CNContact *contact in contacts) {
        DDHBirthday *birthday = [[DDHBirthday alloc] initWithContact:contact];
        [birthdays addObject:birthday];
    }

    return birthdays;
}

@end
