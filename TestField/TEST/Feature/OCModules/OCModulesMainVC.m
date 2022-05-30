//
//  OCModulesMainVC.m
//  TEST
//
//  Created by 111 on 2021/7/19.
//

#import "OCModulesMainVC.h"
#import "BaseConstants.h"
#import "TEST-Swift.h"

#import "LockTestVC.h"
#import "BlueToothTestVC.h"
#import "GCDTestVC.h"

@interface OCModulesMainVC ()

@property (nonatomic, strong) SwiftObject *swiftObject;

@property (nonatomic, strong) UILabel *ocLabel;


@end

@implementation OCModulesMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //点击按钮截屏
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50,100,300,30)];
    [button setTitle:@"测试蓝牙扫描" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(onBluetoothBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button5 = [[UIButton alloc] initWithFrame:CGRectMake(50,150,300,30)];
    [button5 setTitle:@"测试锁" forState:UIControlStateNormal];
    [button5 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button5];
    [button5 addTarget:self action:@selector(onLockTestBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(50,200,300,30)];
    [button1 setTitle:@"测试多任务" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(onGCDTestBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark - Action
// 测试蓝牙
- (void)onBluetoothBtnAction:(UIButton *)btn {
    [self pushToViewControllerNamed:NSStringFromClass([BlueToothTestVC class])];
}

// 测试锁
- (void)onLockTestBtnAction:(UIButton *)btn {
    [self pushToViewControllerNamed:NSStringFromClass([LockTestVC class])];
}

//测试多任务
- (void)onGCDTestBtnAction:(UIButton *)btn {
    [self pushToViewControllerNamed:NSStringFromClass([GCDTestVC class])];
}

#pragma mark - Skip
/**
 * 跳转到特定页面
 */
- (void)pushToViewControllerNamed:(NSString *)className {
    NSAssert(className != nil, @"传入的类名为空");
    Class classVC = NSClassFromString(className);
    id instance = [[classVC alloc] init];
    if ([instance isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)instance;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


@end
