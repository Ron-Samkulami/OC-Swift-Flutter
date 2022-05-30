//
//  FlutterEntranceVC.m
//  TEST
//
//  Created by mige on 2022/5/16.
//
@import Flutter;
#import "FlutterEntranceVC.h"
#import "AppDelegate.h"

@interface FlutterEntranceVC ()

@end

@implementation FlutterEntranceVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //点击测试按钮
    [self addTestButton];
    
//    //添加双实例
//    [self showDoubleFLutters];
}



/**
 *
 */
//- (void)showDoubleFLutters {
//    FlutterViewController *top = [[FlutterViewController alloc] initWithProject:nil initialRoute:@"/" nibName:nil bundle:nil];
//    FlutterViewController *bottom = [[FlutterViewController alloc] initWithProject:nil initialRoute:@"/" nibName:nil bundle:nil];
//    [GeneratedPluginRegistrant registerWithRegistry:top];
//    [GeneratedPluginRegistrant registerWithRegistry:bottom];
//    [self addChildViewController:top];
//    [self addChildViewController:bottom];
//
//    CGRect rect = self.view.frame;
//    CGFloat halfHeight = rect.size.height/2.0;
//    top.view.frame = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), rect.size.width, halfHeight+85);
//    bottom.view.frame = CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(top.view.frame)-170, rect.size.width, halfHeight+85);
//    [self.view addSubview:top.view];
//    [self.view addSubview:bottom.view];
//
//    [top didMoveToParentViewController:self];
//    [bottom didMoveToParentViewController:self];
//}


- (void)addTestButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50,50,300,30)];
    [button setTitle:@"跳转Flutter页面" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(onSkipAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(50,100,300,30)];
    [button2 setTitle:@"跳转Flutter页面" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(onSkipAction2:) forControlEvents:UIControlEventTouchUpInside];
}


/**
 * 跳转
 */
- (void)onSkipAction:(UIButton *)btn {
    FlutterEngine *flutterEngine =
    ((AppDelegate *)UIApplication.sharedApplication.delegate).flutterEngine;
    FlutterViewController *flutterViewController =
    [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    [self presentViewController:flutterViewController animated:YES completion:nil];
    
}

- (void)onSkipAction2:(UIButton *)btn {

    //以下方式会隐式创建flutterEngine,导致加载需要等待一会
    FlutterViewController *vc = [[FlutterViewController alloc] initWithProject:nil initialRoute:@"/" nibName:nil bundle:nil];
    [GeneratedPluginRegistrant registerWithRegistry:vc];
    vc.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"ExitMethodChannel" binaryMessenger:vc.binaryMessenger];
    
    //2. 设置监听回调block，flutter端通过通道调用原生方法时会进入以下回调
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        //call的属性method是flutter调用原生方法的方法名，我们进行字符串判断然后写入不同的逻辑
        if ([call.method isEqualToString:@"homePageCallNativeMethond"]) {
            id para = call.arguments; //flutter传给原生的参数
            // do something  nativeAction
            NSString *nativeActionResult = @"原生给flutter回传的值"; //或者一个BOOL值
            if (nativeActionResult != nil) {
                //nativeAction成功，传值给flutter
                result(nativeActionResult);
            } else {
                //nativeAction异常，向flutter抛出异常 进入catch处理)
                result([FlutterError errorWithCode:@"001" message:@"进入异常处理" details:@"进入flutter的trycatch方法的catch方法"]);
            }
        } else if ([call.method isEqualToString:@"exit"]) {
            [self.navigationController popViewControllerAnimated:YES];
            self.navigationController.navigationBarHidden = NO;
        } else {
            //调用的方法原生没有对应的处理  抛出未实现的异常
            result(FlutterMethodNotImplemented);
        }
    }];
    
}





@end
