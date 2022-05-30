//
//  RSCircularMenu.h
//  TEST
//
//  Created by 111 on 2021/12/22.
//
/**
 *  环形菜单
 *
 *  @author Ron
 */

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, RSIconType) {
    RSIconTypePlus = 0, // 默认“+”
    RSIconTypeUserDraw,  // 用户自定义
    RSIconTypeCustomImage, // 图片
}; //中心图标样式

@interface RSCircularMenu : UIControl

/**
 *  主色
 */
@property (nonatomic, strong) UIColor* mainColor;

/**
 *  中心按钮大小，默认(50,50)
 */
@property (nonatomic, assign) CGSize centerButtonSize;

/**
 *  中心图标样式
 */
@property (nonatomic, assign) RSIconType centerIconType;

/**
 *  中心按钮填充图片，RSIconTypeCustomImage下生效，默认为 nil
 */
@property (nonatomic, strong) UIImage* centerIcon;

/**
 是否打开
 */
@property (nonatomic, assign) BOOL isOpened;

/**
 * 打开菜单后的偏移量
 */
@property (nonatomic, assign) CGSize offsetAfterOpened;

/**
 * 外圈按钮点击事件
 */
@property (nonatomic, strong) void (^buttonClickBlock) (NSInteger idx);

/**
 *  RSIconTypeUserDraw, 可在这里自定义
 */
@property (nonatomic, strong) void (^drawCenterButtonIconBlock)(CGRect rect , UIControlState state);


/**
 *  设置方法
 *
 *  @param icons        icon 数组
 *  @param innerCircleRadius  内径半径
 */
- (void)loadButtonWithIcons:(NSArray<UIImage*>*)icons innerCircleRadius:(CGFloat)innerCircleRadius;

@end

