//
//  RSFPSMonitor.h
//  TEST
//
//  Created by 111 on 2021/8/19.
//
/**
 *  fps检测
 *
 *  @author Ron
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSFPSMonitor : NSObject

+ (instancetype)sharedMonitor;

/**
 显示FPS
 */
- (void)showFPS;

/**
 隐藏FPS
 */
- (void)dismissFPS;

@end

NS_ASSUME_NONNULL_END
