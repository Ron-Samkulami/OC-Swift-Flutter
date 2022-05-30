//
//        RSStuckMonitor.m
 //       2022/2/23
//        
//        
//        Author: Ron
//        MainPage: https://github.com/Ron-Samkulami/
//        

#import "RSStuckMonitor.h"

int timeoutCount;

@interface RSStuckMonitor ()
{
    dispatch_semaphore_t dsema;
    CFRunLoopObserverRef observer;
    CFRunLoopActivity runLoopActivity;
}
@end

@implementation RSStuckMonitor

+ (instancetype)sharedMonitor {
    static RSStuckMonitor *monitor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[RSStuckMonitor alloc] init];
    });
    return monitor;
}


/**
 RunLoop状态观察者回调
 */
void observerCallBack (CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    //更新监视器的对应成员变量
    RSStuckMonitor *monitor = (__bridge RSStuckMonitor *)info;
    monitor->runLoopActivity = activity;
    dispatch_semaphore_signal(monitor->dsema);
    
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
        case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit");
            break;
        default:
            break;
    }
    
}

- (void)startWatching:(CFRunLoopObserverRef)observer {
    if (!dsema) {
        dsema = dispatch_semaphore_create(0);
    }
    
    //创建子线程监控
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //子线程开启一个持续的loop用来进行监控
        while (YES) {
            //observerCallBack每次回调都会signal使dsema+1，从而调用dispatch_semaphore_wait，因此这里的超时时间表示两次RunLoop间隔
            long semaphoreWait = dispatch_semaphore_wait(self->dsema, dispatch_time(DISPATCH_TIME_NOW, 20*NSEC_PER_MSEC));
            //超时时 semaphoreWait 返回 non-zero
            if (semaphoreWait != 0) {
                
                if (!observer) {
                    timeoutCount = 0;
                    self->dsema = 0;
                    self->runLoopActivity = 0;
                    return;
                }
                
                //两个runloop的状态，BeforeSources和AfterWaiting这两个状态区间时间能够检测到是否卡顿
                if (self->runLoopActivity == kCFRunLoopBeforeSources || self->runLoopActivity == kCFRunLoopAfterWaiting) {
                    //出现三次出结果
                    if (++timeoutCount < 3) {
                        continue;
                    }
                    NSLog(@"StuckMonitor trigger");
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        //发生卡顿，上报数据
                    });
                } //end activity
                
            }// end semaphore wait
            timeoutCount = 0;
        }// end while
    });
}

- (void)start {
    //注册RunLoop状态观察者
    CFRunLoopObserverContext context = {0,(__bridge void *)self,NULL,NULL,NULL};
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, observerCallBack, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    //开始监测
    [self startWatching:observer];
}

- (void)stop {
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}

@end
