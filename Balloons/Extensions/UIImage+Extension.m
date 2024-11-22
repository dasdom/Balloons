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

        UIBezierPath *path;
//        if (rand() % 2 == 0) {
            path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, bleedRect.size.width, bleedRect.size.height)];
            [path addClip];
//        } else {
//            path = [[UIBezierPath alloc] init];
//            [path moveToPoint:CGPointMake(targetSize.width/2 - targetSize.width * 0.06, targetSize.height)];
//            [path addCurveToPoint:CGPointMake(targetSize.width/2 + targetSize.width * 0.1, targetSize.height)
//                    controlPoint1:CGPointMake(targetSize.width/2 + 1.6 * targetSize.width, -0.33 * targetSize.height)
//                    controlPoint2:CGPointMake(targetSize.width/2 - 1.6 * targetSize.width, -0.33 * targetSize.height)];
//            [path closePath];
//            [path addClip];
//        }

        CGRect strokeRect = CGRectInset(breadthRect, -width/2, -width/2);
        strokeRect = CGRectMake(width/2, width/2, strokeRect.size.width, strokeRect.size.height);

        [self drawInRect:strokeRect];
        [color setStroke];

//        UIBezierPath *line = [UIBezierPath bezierPathWithOvalInRect:strokeRect];
        path.lineWidth = width;
        [path stroke];
    }];

    return roundedImage;
}

+ (UIImage *)initialsImageWithPersonNameComponents:(NSPersonNameComponents *)nameComponents {

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont boldSystemFontOfSize:26];
//    label.layer.cornerRadius = 25;
    
    NSPersonNameComponentsFormatter *nameFormatter = [[NSPersonNameComponentsFormatter alloc] init];
    nameFormatter.style = NSPersonNameComponentsFormatterStyleAbbreviated;
    label.text = [nameFormatter stringFromPersonNameComponents:nameComponents];

    UIGraphicsImageRenderer *imageRenderer = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(50, 50)];
    UIImage *image = [imageRenderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        [[UIColor systemOrangeColor] setFill];
        CGContextFillEllipseInRect(rendererContext.CGContext, CGRectMake(0, 0, 50, 50));

//        UIBezierPath *path = [[UIBezierPath alloc] init];
//        [path moveToPoint:CGPointMake(size.width/2 - size.width * 0.1, size.height)];
//        [path addCurveToPoint:CGPointMake(size.width/2 + size.width * 0.1, size.height)
//                controlPoint1:CGPointMake(size.width/2 + 1.4 * size.width, -size.height/3)
//                controlPoint2:CGPointMake(size.width/2 - 1.4 * size.width, -size.height/3)];
//
//        [path fill];

        [label drawTextInRect:label.frame];
    }];

    return image;
}
@end
