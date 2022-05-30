//
//  RSScaleToSize.m
//  TEST
//
//  Created by 111 on 2021/12/20.
//

#import "UIImage+RSScaleToSize.h"

@implementation UIImage (RSScaleToSize)
+ (UIImage*)scaleImage:(UIImage*)image toTargetSize:(CGSize)targetSize {
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0,0, targetSize.width, targetSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scale {
    CGSize targetSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    return [UIImage scaleImage:image toTargetSize:targetSize];
}
@end
