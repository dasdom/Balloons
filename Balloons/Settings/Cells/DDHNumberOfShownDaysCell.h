//  Created by Dominik Hauser on 23.11.24.
//  
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHNumberOfShownDaysCell : UITableViewCell
@property (nonatomic, strong) UISegmentedControl *daysSegmentedControl;
+ (NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
