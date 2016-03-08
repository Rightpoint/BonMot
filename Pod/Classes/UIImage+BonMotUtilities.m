//
//  UIImage+BonMotUtilities.m
//  BonMot
//
//  Created by Zev Eisenberg on 5/11/15.
//
//

#import "UIImage+BonMotUtilities.h"

@implementation UIImage (BonMotUtilities)

- (UIImage *)bon_tintedImageWithColor:(UIColor *)color
{
    NSParameterAssert(color);

    // Save original properties
    UIEdgeInsets originalCapInsets = self.capInsets;
    UIImageResizingMode originalResizingMode = self.resizingMode;
    UIEdgeInsets originalAlignmentRectInsets = self.alignmentRectInsets;

    // Create image context
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    // Flip the context vertically
    CGContextTranslateCTM(ctx, 0.0, self.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);

    CGRect imageRect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);

    // Image tinting mostly inspired by http://stackoverflow.com/a/22528426/255489

    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    CGContextDrawImage(ctx, imageRect, self.CGImage);

    // kCGBlendModeSourceIn: resulting color = source color * destination alpha
    CGContextSetBlendMode(ctx, kCGBlendModeSourceIn);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, imageRect);

    // Get new image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // Restore original properties
    image = [image imageWithAlignmentRectInsets:originalAlignmentRectInsets];
    if (!UIEdgeInsetsEqualToEdgeInsets(originalCapInsets, image.capInsets) || originalResizingMode != image.resizingMode) {
        image = [image resizableImageWithCapInsets:originalCapInsets resizingMode:originalResizingMode];
    }

    return image;
}

@end
