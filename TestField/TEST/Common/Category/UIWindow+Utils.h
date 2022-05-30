//
//  UIWindow+Utils.h
//  TEST
//
//  Created by 111 on 2021/7/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (Utils)
/// 主窗口
+ (UIWindow*)keyWindow;
/// 当前窗口
+ (UIWindow*)currentWindow;

@end

NS_ASSUME_NONNULL_END
