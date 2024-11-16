//  Created by Dominik Hauser on 04.05.24.
//
//


#import "UIImage+Extension.h"

@implementation UIImage (Extension)
// https://stackoverflow.com/a/34985608/498796
// https://stackoverflow.com/a/40867644/498796
- (UIImage *)roundedWithColor:(UIColor *)color width:(CGFloat)width targetSize:(CGSize)targetSize {
    CGRect breadthRect = CGRectMake(0, 0, targetSize.width, targetSize.height);
    CGRect bleedRect = CGRectInset(breadthRect, -width, -width);
    UIGraphicsImageRendererFormat *imageRendererFormat = self.imageRendererFormat;
    imageRendererFormat.opaque = NO;

    UIGraphicsImageRenderer *imageRenderer = [[UIGraphicsImageRenderer alloc] initWithSize:bleedRect.size format:imageRendererFormat];
    UIImage *roundedImage = [imageRenderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {

        [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, bleedRect.size.width, bleedRect.size.height)] addClip];

        CGRect strokeRect = CGRectInset(breadthRect, -width/2, -width/2);
        strokeRect = CGRectMake(width/2, width/2, strokeRect.size.width, strokeRect.size.height);

        [self drawInRect:strokeRect];
        [color setStroke];

        UIBezierPath *line = [UIBezierPath bezierPathWithOvalInRect:strokeRect];
        line.lineWidth = width;
        [line stroke];
    }];

    return roundedImage;
}

+ (UIImage *)initialsImageWithPersonNameComponents:(NSPersonNameComponents *)nameComponents {

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.textColor = [UIColor yellowColor];
    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont boldSystemFontOfSize:26];
//    label.layer.cornerRadius = 25;
    
    NSPersonNameComponentsFormatter *nameFormatter = [[NSPersonNameComponentsFormatter alloc] init];
    nameFormatter.style = NSPersonNameComponentsFormatterStyleAbbreviated;
    label.text = [nameFormatter stringFromPersonNameComponents:nameComponents];

    UIGraphicsImageRenderer *imageRenderer = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(50, 50)];
    UIImage *image = [imageRenderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        [[UIColor brownColor] setFill];
        CGContextFillEllipseInRect(rendererContext.CGContext, CGRectMake(0, 0, 50, 50));

        [label drawTextInRect:label.frame];
    }];

    return image;
}
@end
