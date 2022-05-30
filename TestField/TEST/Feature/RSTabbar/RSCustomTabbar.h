//
//  RSCustomTabbar.m
//  TEST
//
//  Created by 111 on 2021/12/20.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(UIButton* _Nonnull btn);

@interface RSCustomTabbar : UITabBar

@property (nonatomic, copy) ClickBlock _Nullable btnClickBlock;

+ (void)setTabBarUI:(NSArray*)views tabBar:(UITabBar*)tabBar topLineColor:(UIColor*)lineColor backgroundColor:(UIColor*)backgroundColor;

@end

