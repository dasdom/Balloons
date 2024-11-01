//  Created by Dominik Hauser on 04.05.24.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CNContact;

@interface DDHBirthday : NSObject
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, assign) NSInteger daysLeft;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSPersonNameComponents *personNameComponents;
@property (nonatomic, readonly) Boolean yearUnknown;

- (instancetype)initWithUUID:(NSUUID *)uuid imageData:(NSData *)imageData daysLeft:(NSInteger)daysLeft date:(NSDate *)date personNameComponents:(NSPersonNameComponents *)personNameComponents;
- (instancetype)initWithContact:(CNContact *)contact;
@end

NS_ASSUME_NONNULL_END
