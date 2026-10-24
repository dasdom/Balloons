//  Created by Dominik Hauser on 04.03.26.
//  
//


#import <Foundation/Foundation.h>
#import "DDHBalloonPresentableProtocol.h"
#import "DDHNotificationRequestableProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDHEvent : NSObject <DDHBalloonPresentableProtocol, DDHNotificationRequestableProtocol>
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic, strong) NSString *emoji;
@property (nonatomic, assign) NSInteger daysLeft;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *name;
@property (assign) BOOL favorite;

- (instancetype)initWithUUID:(NSUUID *)uuid date:(NSDate *)date emoji:(NSString *)emoji name:(NSString *)name favorite:(BOOL)favorite;
- (void)updateDaysLeft;
@end

NS_ASSUME_NONNULL_END
