//
//        RSStuckMonitor.h
 //       2022/2/23
//        
//        
//        Author: Ron
//        MainPage: https://github.com/Ron-Samkulami/
//        
/**
 *  卡顿监测
 *
 *  @author Ron
 */

#import <Foundation/Foundation.h>


@interface RSStuckMonitor : NSObject 
+ (instancetype)sharedMonitor;

- (void)start;

- (void)stop;

@end

