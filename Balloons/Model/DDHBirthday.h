//  Created by Dominik Hauser on 04.05.24.
//  
//


#import <Foundation/Foundation.h>
#import "DDHBalloonPresentableProtocol.h"
#import "DDHNotificationRequestableProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class CNContact;

@interface DDHBirthday : NSObject <DDHBalloonPresentableProtocol, DDHNotificationRequestableProtocol>
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, assign) NSInteger daysLeft;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSPersonNameComponents *personNameComponents;
@property (nonatomic, assign) BOOL yearUnknown;
@property (assign) BOOL favorite;

- (instancetype)initWithUUID:(NSUUID *)uuid date:(NSDate *)date personNameComponents:(NSPersonNameComponents *)personNameComponents yearUnknown:(BOOL)yearUnknown favorite:(BOOL)favorite;
- (instancetype)initWithContact:(CNContact *)contact;
- (void)updateDaysLeft;
- (void)saveImageData:(NSData *)imageData personUUID:(NSUUID *)uuid;
@end

NS_ASSUME_NONNULL_END
