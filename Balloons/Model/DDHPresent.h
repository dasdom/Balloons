//  Created by Dominik Hauser on 23.04.25.
//  
//


#import <Foundation/Foundation.h>

@interface DDHPresent : NSObject
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic, strong) NSUUID *birthdayUUID;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSDate *givenAwayDate;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, strong) NSString *note;
- (instancetype)initWithUUID:(NSUUID *)uuid birthdayUUID:(NSUUID *)birthdayUUID url:(NSURL *)url title:(NSString *)title givenAwayDate:(NSDate *)givenAwayDate priority:(NSInteger)priority note:(NSString *)note;
@end

