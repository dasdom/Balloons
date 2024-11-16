//  Created by Dominik Hauser on 12.11.24.
//  
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (Extensions)
- (NSURL *)databaseURL;
- (NSURL *)imageURLWithPersonUUID:(NSUUID *)uuid;
@end

NS_ASSUME_NONNULL_END
