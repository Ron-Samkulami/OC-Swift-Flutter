//
//  MainTabBarController.m
//  TEST
//
//  Created by 111 on 2021/7/19.
//

#import "MainTabBarController.h"
//utils
#import "UIWindow+Utils.h"
#import "BaseConstants.h"
#import "UIViewController+Monitor.h"
#import <AudioToolbox/AudioToolbox.h>
//subVC
#import "WidgetTestFieldVC.h"
#import "OCModulesMainVC.h"
#import "RSCustomTabbar.h"
#import "TEST-Swift.h"
#import "AVTestFieldVC.h"
#import "FlutterEntranceVC.h"


@interface MainTabBarController ()

@end

@implementation MainTabBarController

+ (void)initialize {
    //tabbar去掉顶部黑线
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RSCustomTabbar * tabbar = [[RSCustomTabbar alloc] init];
    //中间自定义tabBar点击事件
    @weakify(self);
    tabbar.btnClickBlock = ^(UIButton *btn) {
        @strongify(self);
        self.selectedIndex = 2;
    };
    [self setValue:tabbar forKeyPath:@"tabBar"];
    
    [self setupSubVC];
}


- (void)setupSubVC {
    //控件测试
    WidgetTestFieldVC * testFieldVC = [[WidgetTestFieldVC alloc] init];
    testFieldVC.view.backgroundColor = [[UIColor systemPinkColor] colorWithAlphaComponent:0.2];
    UINavigationController *NC1 = [self getNavigationVCWithChildVC:testFieldVC title:@"控件测试" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    //音视频模块
    AVTestFieldVC * avTestFieldVC = [[AVTestFieldVC alloc] init];
    avTestFieldVC.view.backgroundColor = [[UIColor systemPurpleColor] colorWithAlphaComponent:0.2];
    UINavigationController *NC2 = [self getNavigationVCWithChildVC:avTestFieldVC title:@"编解码" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
    //Tab中间凸起
    FlutterEntranceVC *vc3 = [[FlutterEntranceVC alloc] init];
    vc3.view.backgroundColor = [[UIColor systemGreenColor] colorWithAlphaComponent:0.2];
    UINavigationController *NC3 = [self getNavigationVCWithChildVC:vc3 title:@"Flutter" image:@"tabBar_publish_icon" selectedImage:@"tabBar_publish_click_icon"];
    
    //OCPage
    OCModulesMainVC *ocMainPage = [[OCModulesMainVC alloc] init];
    ocMainPage.view.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.2];
    UINavigationController *NC4 = [self getNavigationVCWithChildVC:ocMainPage title:@"单元测试" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    //Swift模块
    SwiftViewController *swiftVC = [[SwiftViewController alloc] init];
    swiftVC.view.backgroundColor = [[UIColor systemYellowColor] colorWithAlphaComponent:0.2];
    UINavigationController *NC5 = [self getNavigationVCWithChildVC:swiftVC title:@"Swift混编" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    self.viewControllers = @[NC1,NC2,NC3,NC4,NC5];
}

- (UINavigationController*)getNavigationVCWithChildVC:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    // 设置子控制器
    childVc.title = title;
    childVc.edgesForExtendedLayout = UIRectEdgeNone;//边缘不穿透，不写不显示导航栏
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateSelected];
    
    //用导航控制器包裹子控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    return nav;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//
    [RSCustomTabbar setTabBarUI:self.tabBar.subviews tabBar:self.tabBar topLineColor:[UIColor grayColor] backgroundColor:self.tabBar.barTintColor];
}


#pragma mark - 摇一摇
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        //振动效果
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        //摇一摇截图
        [self saveScreenShot];
    }
}

#pragma mark - 截屏
- (void)saveScreenShot {
    UIImage *image = [self getScreenShot];
    if (image != nil) {
        //显示预览图
        [self saveImage:image];
    }
}

- (UIImage *)getScreenShot {
    UIWindow *screenWindow = [UIWindow keyWindow];  //self.view.window
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(screenWindow.bounds.size, NO, [UIScreen mainScreen].scale);//ritina
    } else {
        UIGraphicsBeginImageContext(screenWindow.bounds.size);
    }
//    UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, NO, 0.0); // no ritina
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if(window == screenWindow) {
            break;
        } else {
            [window.layer renderInContext:context];
        }
    }
    if ([screenWindow respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        //这个方式可以解决截视频黑屏的问题
        [screenWindow drawViewHierarchyInRect:screenWindow.bounds afterScreenUpdates:YES];
    } else {
        [screenWindow.layer renderInContext:context];
    }
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    screenWindow.layer.contents = nil;
    UIGraphicsEndImageContext();

    return image;
}

//保存图片
- (void)saveImage:(UIImage *)image {
    WS(ws)
    //异步存到相册中
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (image != nil) {
            UIImageWriteToSavedPhotosAlbum(image, ws, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    });
}

//保存图片后的结果
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [self toast:@"保存截图失败"];
    } else {
        [self toast:@"保存截图成功"];
    }
}

@end
