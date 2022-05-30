//
//  RSCustomTabbar.m
//  TEST
//
//  Created by 111 on 2021/12/20.
//

#ifndef TabBarConst_h
#define TabBarConst_h

/**
 tabbar高度
 */
#define  rs_tabbarHeight         ((rs_iPhoneX || rs_iPhoneXr || rs_iPhoneXs || rs_iPhoneXsMax) ? (49.f + 34.f) : 49.f)
// 判断是否是ipad
#define rs_isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
// 判断iPhoneX
#define rs_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !rs_isPad : NO)
// 判断iPHoneXr
#define rs_iPhoneXr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !rs_isPad : NO)
// 判断iPhoneXs
#define rs_iPhoneXs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !rs_isPad : NO)
// 判断iPhoneXs Max
#define rs_iPhoneXsMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !rs_isPad : NO)
/**
 底部安全间距
 */
#define rs_safeBottomMargin  ((rs_iPhoneX || rs_iPhoneXr || rs_iPhoneXs || rs_iPhoneXsMax) ? 34.f : 0.f)

#endif /* TabBarConst_h */
