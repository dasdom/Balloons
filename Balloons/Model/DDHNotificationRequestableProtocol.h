//  Created by Dominik Hauser on 09.03.26.
//  
//


#ifndef DDHNotificationRequestableProtocol_h
#define DDHNotificationRequestableProtocol_h

@class UNNotificationRequest;

@protocol DDHNotificationRequestableProtocol <NSObject>
- (UNNotificationRequest *)notificationRequest;
@end

#endif /* DDHNotificationRequestableProtocol_h */
