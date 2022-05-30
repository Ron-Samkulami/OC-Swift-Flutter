//
//  UIWindow+Utils.m
//  TEST
//
//  Created by 111 on 2021/7/27.
//

#import "UIWindow+Utils.h"

@implementation UIWindow (Utils)

+ (UIWindow*)keyWindow {
    UIWindow *foundWindow = nil;
    NSArray  *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow  *window in windows) {
        if (window.isKeyWindow) {
            foundWindow = window;
            break;
        }
    }
    return foundWindow;
}

+ (UIWindow*)currentWindow {
    
    if ([[[UIApplication sharedApplication] delegate] window]) {
        return [[[UIApplication sharedApplication] delegate] window];
    } else {
        if (@available(iOS 13.0,*)) {
            UIWindow *foundWindow = nil;
            NSArray  *windows = [[UIApplication sharedApplication]windows];
            for (UIWindow  *window in windows) {
                if (window.isKeyWindow) {
                    foundWindow = window;
                    break;
                }
            }
            return foundWindow;
        } else {
            return  [UIApplication sharedApplication].keyWindow;
        }
    }
}
@end
