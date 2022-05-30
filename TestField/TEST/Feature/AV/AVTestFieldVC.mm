//
//        AVTestFieldVC.m
 //       2022/1/14
//        
//        
//        Author: Ron
//        MainPage: https://github.com/Ron-Samkulami/
//        

#import "AVTestFieldVC.h"
#import "UIViewController+Monitor.h"
#import "Mp3Encoder.hpp"

@interface AVTestFieldVC ()

@end

@implementation AVTestFieldVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTestView];
}

- (void)addTestView {
    //开始编码
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50,50,300,30)];
    [button setTitle:@"Encode" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(onEncodeAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onEncodeAction:(UIButton *)sender {
    [self toast:@"Start Encoding"];
    Mp3Encoder* encoder = new Mp3Encoder();
    encoder->Encode();
    delete encoder;
}

@end
