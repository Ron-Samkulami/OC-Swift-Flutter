//
//  ViewController.m
//  TEST
//
//  Created by 111 on 2020/9/18.
//

#import "ViewController.h"
#import "MainTabBarController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MainTabBarController *mtbc = [[MainTabBarController alloc] init];
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    window.backgroundColor = [UIColor whiteColor];
    window.rootViewController = mtbc;
    
}


@end
