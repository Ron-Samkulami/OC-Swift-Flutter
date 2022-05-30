//
//  RSScaleToSize.h
//  TEST
//
//  Created by 111 on 2021/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (RSScaleToSize)

/**
 按尺寸缩放图片
 
 @param image 原始图片
 @param targetSize  目标尺寸
 */
+ (UIImage*)scaleImage:(UIImage*)image toTargetSize:(CGSize)targetSize;

/**
 按比例缩放图片
 
 @param image 原始图片
 @param scale 比例系数
 */
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scale;

@end

NS_ASSUME_NONNULL_END
