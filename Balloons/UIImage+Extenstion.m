//  Created by Dominik Hauser on 04.05.24.
//
//


#import "UIImage+Extenstion.h"

@implementation UIImage (Extenstion)
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
@end
