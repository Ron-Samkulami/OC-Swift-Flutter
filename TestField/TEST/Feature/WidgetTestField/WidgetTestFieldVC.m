//
//  WidgetTestFieldVC.m
//  TEST
//
//  Created by 111 on 2021/7/28.
//

#import "WidgetTestFieldVC.h"
#import "BaseConstants.h"
#import "UIViewController+Monitor.h"
#import "RSFPSMonitor.h"
#import "RSFloatContentBtn.h"
#import "RSCircularMenu.h"
//#import <AVKit/AVKit.h>

@interface WidgetTestFieldVC ()



@end

@implementation WidgetTestFieldVC {
    UILabel *_fpsLabel;
    CADisplayLink *_link;
    NSTimeInterval _lastTime;
    float _fps;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置调试视图
    [self setUpDebugView];
    
    [self addCircularMenu];
    
}


/**
 设置调试视图
 */
- (void)setUpDebugView {
    //点击测试按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50,50,300,30)];
    [button setTitle:@"显示FPS" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(onShowAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //点击测试按钮
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(50,100,300,30)];
    [button2 setTitle:@"隐藏FPS" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(onDismissAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //悬浮按钮
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(50,150,300,30)];
    [button3 setTitle:@"显示浮动按钮" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button3];
    [button3 addTarget:self action:@selector(onShowFloatingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(50,200,300,30)];
    [button4 setTitle:@"隐藏浮动按钮" forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button4];
    [button4 addTarget:self action:@selector(onDismissFloatingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark FPS开关
- (void)onShowAction:(UIButton *)btn {
    [[RSFPSMonitor sharedMonitor] showFPS];
}

- (void)onDismissAction:(UIButton *)btn {
    [[RSFPSMonitor sharedMonitor] dismissFPS];
}

#pragma mark 悬浮按钮
- (void)onShowFloatingBtnAction:(UIButton *)btn {
    //debug模式显示悬浮按钮
    [[RSFloatContentBtn shared] showInDebugModeWithType:RSAssistiveTypeNone];
    //显示时间戳
    [[RSFloatContentBtn shared] setBuildShowDate:YES];
}

- (void)onDismissFloatingBtnAction:(UIButton *)btn {
    [[RSFloatContentBtn shared] dismiss];
}

#pragma mark - CircularMenu

/**
 添加浮动按钮
 */
- (void)addCircularMenu {
    RSCircularMenu *menu = [[RSCircularMenu alloc] initWithFrame:CGRectMake(DeviceWidth-200, 50, 300, 300)];
    menu.centerButtonSize = CGSizeMake(50, 50);
    [menu loadButtonWithIcons:@[
        [UIImage imageNamed:@"tabBar_essence_click_icon"],
        [UIImage imageNamed:@"tabBar_friendTrends_click_icon"],
        [UIImage imageNamed:@"tabBar_me_click_icon"],
        [UIImage imageNamed:@"tabBar_essence_click_icon"],
        [UIImage imageNamed:@"tabBar_friendTrends_click_icon"],
        [UIImage imageNamed:@"tabBar_me_click_icon"],
        [UIImage imageNamed:@"tabBar_essence_click_icon"],
        [UIImage imageNamed:@"tabBar_friendTrends_click_icon"],
        [UIImage imageNamed:@"tabBar_me_click_icon"],
        [UIImage imageNamed:@"tabBar_essence_click_icon"],
        [UIImage imageNamed:@"tabBar_friendTrends_click_icon"],
        [UIImage imageNamed:@"tabBar_me_click_icon"],
        [UIImage imageNamed:@"tabBar_essence_click_icon"]
    ]
            innerCircleRadius:100];
    [menu setButtonClickBlock:^(NSInteger idx) {
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [UIColor redColor];
        NSLog(@"button %@ clicked !",@(idx));
        printf("button %zd clicked ",idx);
        [self presentViewController:vc animated:YES completion:nil];
        
    }];
    
//    menu.offsetAfterOpened = CGSizeMake(50, 0);
    
//    [menu setCenterIcon:[UIImage imageNamed:@"tabBar_new_click_icon"]];
//    [menu setCenterIconType:RSIconTypeCustomImage];
    
    menu.tintColor = [UIColor whiteColor];
    menu.mainColor = [UIColor systemYellowColor];
    
    [self.view addSubview:menu];
}

@end



