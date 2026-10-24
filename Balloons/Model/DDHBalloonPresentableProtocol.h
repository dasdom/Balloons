//  Created by Dominik Hauser on 06.03.26.
//  
//

#import <Foundation/Foundation.h>

#ifndef DDHBalloonPresentableProtocol_h
#define DDHBalloonPresentableProtocol_h

@protocol DDHBalloonPresentableProtocol <NSObject>
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic, assign) NSInteger daysLeft;
@property (nonatomic, strong) NSDate *date;

- (NSString *)name;
- (NSString *)balloonText;
- (NSString *)detailStringWithNameFormatter:(NSPersonNameComponentsFormatter *)nameFormatter dateFormatterWithYear:(NSDateFormatter *)dateFormatterWithYear dateFormatterWithoutYear:(NSDateFormatter *)dateFormatterWithoutYear;

@optional
@property (nonatomic, strong) NSData *imageData;
@end

#endif /* DDHBalloonPresentableProtocol_h */
