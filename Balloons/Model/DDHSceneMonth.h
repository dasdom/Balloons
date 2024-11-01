//  Created by Dominik Hauser on 10.05.24.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHSceneMonth : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger end;
- (instancetype)initWithName:(NSString *)name start:(NSInteger)start end:(NSInteger)end;
@end

NS_ASSUME_NONNULL_END
