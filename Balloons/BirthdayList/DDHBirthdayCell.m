//  Created by Dominik Hauser on 15.01.25.
//  
//


#import "DDHBirthdayCell.h"
#import "DDHBirthday.h"
#import "UIImage+Extension.h"

@interface DDHBirthdayCell ()
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) NSArray<UIImageView *> *balloonImageViews;
@end

@implementation DDHBirthdayCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        _dateLabel.font = [UIFont monospacedSystemFontOfSize:50 weight:UIFontWeightBold];
//        _dateLabel.textAlignment = NSTextAlignmentRight;

        [self.contentView addSubview:_dateLabel];

        [NSLayoutConstraint activateConstraints:@[
            [_dateLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [_dateLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
            [_dateLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
            [_dateLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
        ]];
    }
    return self;
}

- (void)updateWithBirthdays:(NSArray<DDHBirthday *> *)birthdays dateFormatter:(NSDateFormatter *)dateFormatter date:(NSDate *)date daysLeft:(NSInteger)daysLeft {

    for (UIView *subView in self.balloonImageViews) {
        [subView removeFromSuperview];
    }

    CGFloat hue = daysLeft/366.0;
    UIColor *backgroundColor = [UIColor systemGray6Color]; //[UIColor colorWithHue:hue saturation:0.7 brightness:0.7 alpha:1];

    self.dateLabel.attributedText = [[NSAttributedString alloc] initWithString:[dateFormatter stringFromDate:date] attributes:@{NSForegroundColorAttributeName: [UIColor systemGray4Color], NSFontAttributeName: [UIFont monospacedSystemFontOfSize:24 weight:UIFontWeightBold], NSTextEffectAttributeName: NSTextEffectLetterpressStyle}];

    NSMutableArray *balloonImageViews = [[NSMutableArray alloc] init];
    for (DDHBirthday *birthday in birthdays) {
        UIImage *roundedImage;
        if (birthday.imageData) {
            UIImage *image = [UIImage imageWithData:birthday.imageData];
            roundedImage = [image roundedWithColor:[UIColor whiteColor] width:10 targetSize:CGSizeMake(400, 400)];
        } else {
            roundedImage = [UIImage initialsImageWithPersonNameComponents:birthday.personNameComponents];
        }
        if (roundedImage) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:roundedImage];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [imageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

            [self.contentView addSubview:imageView];
            [balloonImageViews addObject:imageView];

            [NSLayoutConstraint activateConstraints:@[
                [imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
                [imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:60],
                [imageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
                [imageView.widthAnchor constraintEqualToAnchor:imageView.heightAnchor],
            ]];
        }
    }
    self.balloonImageViews = [balloonImageViews copy];

    self.backgroundColor = backgroundColor;
}
@end
