//
//  RSFloatContentBtn.h
//  TEST
//
//  Created by 111 on 2021/12/20.
//
/**
 *  悬浮可移动按钮
 *
 *  @author Ron
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^floatBtnClick)(UIButton *sender);

typedef NS_ENUM(NSInteger, RSAssistiveTouchType) {
    RSAssistiveTypeNone = 0,   //自动识别贴边
    RSAssistiveTypeNearLeft,   //拖动停止之后，自动向左贴边
    RSAssistiveTypeNearRight,  //拖动停止之后，自动向右贴边
};

@interface RSFloatContentBtn : UIButton

/// 按钮点击事件
@property (nonatomic, copy) floatBtnClick btnClick;
/// 样式
@property (nonatomic, assign) RSAssistiveTouchType type;

/// 所有操作都通过单例进行
+ (instancetype)shared;
/// 显示
- (void)show;
/// 隐藏
- (void)dismiss;


/// 创建单例并显示
+ (instancetype)showWithType:(RSAssistiveTouchType)type;
/// 显示
- (void)showWithType:(RSAssistiveTouchType)type;
/// 只在Debug模式下显示
- (void)showInDebugModeWithType:(RSAssistiveTouchType)type;


/// 设置环境参数
- (void)setEnvironmentMap:(NSDictionary *)environmentMap currentEnv:(NSString *)currentEnv;
///是否显示时间戳
- (void)setBuildShowDate:(BOOL)isBuildShowDate;

@end

NS_ASSUME_NONNULL_END
