//  Created by Dominik Hauser on 07.11.24.
//  
//


#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHBirthday;

@interface DDHPersonScene : SKScene
- (instancetype)initWithSize:(CGSize)size birthday:(DDHBirthday *)birthday;
@end

NS_ASSUME_NONNULL_END
