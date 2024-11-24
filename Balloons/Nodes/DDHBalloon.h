//  Created by Dominik Hauser on 27.10.24.
//  
//


#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDHBirthday;

@interface DDHBalloon : SKSpriteNode
@property (nonatomic, strong) NSUUID *birthdayId;
- (instancetype)initWithBirthday:(DDHBirthday *)birthday width:(CGFloat)width;
- (DDHBalloon *)balloonCopyForDetail;
- (void)showLabel:(BOOL)show animated:(BOOL)animated;
- (void)showInfoWithNameFormatter:(NSPersonNameComponentsFormatter *)nameFormatter dateFormatterWithYear:(NSDateFormatter *)dateFormatterWithYear dateFormatterWithoutYear:(NSDateFormatter *)dateFormatterWithoutYear;
@end

NS_ASSUME_NONNULL_END
