//
//  UIImage+BonMotUtilities.h
//  Pods
//
//  Created by Zev Eisenberg on 5/11/15.
//
//

@import UIKit;

@interface UIImage (BonMotUtilities)

/**
 *  Tints an image with the provided color. Preserves the original image’s alignment rect insets, cap insets, and resizing mode.
 *
 *  @param color The color to tint the image. Must not be @c nil.
 *
 *  @return A tinted version of the image.
 */
- (UIImage *)bon_tintedImageWithColor:(UIColor *)color;

@end
