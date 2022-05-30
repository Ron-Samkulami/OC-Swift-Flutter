//
//  AppDelegate.h
//  TEST
//
//  Created by 111 on 2020/9/18.
//

@import Flutter;
#import <UIKit/UIKit.h>
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>

@class MainTabBarController;


@interface AppDelegate : FlutterAppDelegate

@property (nonatomic,strong) FlutterEngine *flutterEngine;

@property (nonatomic, weak) MainTabBarController *tabbarController;     //UITab Bar 控制器

/// 多实例组
@property (nonatomic, strong) FlutterEngineGroup *engines;
@end

