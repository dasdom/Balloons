//  Created by Dominik Hauser on 04.05.24.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CNContact;
@class UNNotificationRequest;

@interface DDHBirthday : NSObject
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, assign) NSInteger daysLeft;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSPersonNameComponents *personNameComponents;
@property (assign) Boolean yearUnknown;

- (instancetype)initWithUUID:(NSUUID *)uuid date:(NSDate *)date personNameComponents:(NSPersonNameComponents *)personNameComponents yearUnknown:(BOOL)yearUnknown;
- (instancetype)initWithContact:(CNContact *)contact;
- (void)updateDaysLeft;
- (UNNotificationRequest *)notificationRequest;
@end

NS_ASSUME_NONNULL_END
