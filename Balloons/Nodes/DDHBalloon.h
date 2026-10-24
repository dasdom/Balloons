//  Created by Dominik Hauser on 27.10.24.
//  
//


#import <SpriteKit/SpriteKit.h>
#import "DDHBalloonPresentableProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class DDHBirthday;

@interface DDHBalloon : SKSpriteNode
@property (nonatomic, strong) NSUUID *itemId;
@property (nonatomic, strong) SKSpriteNode *deleteButtonNode;
@property (nonatomic, strong) SKSpriteNode *presentsButton;
- (instancetype)initWithItem:(id<DDHBalloonPresentableProtocol>)item width:(CGFloat)width color:(UIColor *)color;
- (DDHBalloon *)balloonCopyForDetail;
- (void)showLabel:(BOOL)show animated:(BOOL)animated;
- (void)showInfoWithNameFormatter:(NSPersonNameComponentsFormatter *)nameFormatter dateFormatterWithYear:(NSDateFormatter *)dateFormatterWithYear dateFormatterWithoutYear:(NSDateFormatter *)dateFormatterWithoutYear;
@end

NS_ASSUME_NONNULL_END
