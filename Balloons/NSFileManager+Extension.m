//  Created by Dominik Hauser on 12.11.24.
//  
//


#import "NSFileManager+Extension.h"

@implementation NSFileManager (Extensions)

- (NSURL *)documentsURL {
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSURL *url = [NSURL URLWithString:[paths firstObject]];
    return url;
}

- (NSURL *)databaseURL {
    return [[self documentsURL] URLByAppendingPathComponent:@"birthdays"];
}

- (NSURL *)imageURLWithPersonUUID:(NSUUID *)uuid {
    NSURL *imageDirectory = [[self documentsURL] URLByAppendingPathComponent:@"images"];
    if (NO == [self fileExistsAtPath:[imageDirectory path]]) {
        NSError *error;
        [self createDirectoryAtPath:[imageDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];

        if (error) {
            NSLog(@"Failed to create images directory: %@", error);
            return nil;
        }
    }
    return [imageDirectory URLByAppendingPathComponent:[uuid UUIDString]];
}

@end
