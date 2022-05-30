//
//  RSFPSMonitor.m
//  TEST
//
//  Created by 111 on 2021/8/19.
//

#import "RSFPSMonitor.h"

#import "UIWindow+Utils.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define LabelWidth 60
#define LabelHeight 30

@implementation RSFPSMonitor {
    UILabel *_fpsLabel;
    CADisplayLink *_link;
    NSTimeInterval _lastTimeStamp;
    NSInteger _disPlayCount;
    float _fps;
}

+ (instancetype)sharedMonitor {
    static RSFPSMonitor *monitor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[RSFPSMonitor alloc] init];
    });
    return monitor;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-LabelWidth, 80, LabelWidth, LabelHeight)];
        _fpsLabel.textColor = [UIColor lightGrayColor];
    }
    return self;
}

/**
 显示FPS
 */
- (void)showFPS {
    [self invalidateCurrentCADisplayLink];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication].keyWindow addSubview:_fpsLabel];
#pragma clang diagnostic pop
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(fpsDisplayLinkAction:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

/**
 隐藏FPS
 */
- (void)dismissFPS {
    [self invalidateCurrentCADisplayLink];
    [_fpsLabel removeFromSuperview];
}

/**
 移除当前CADisplayLink
 */
- (void)invalidateCurrentCADisplayLink {
    if (_link) {
        [_link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [_link invalidate];
        _link = nil;
    }
}

- (void)fpsDisplayLinkAction:(CADisplayLink *)link {
    if (_lastTimeStamp == 0) {
        _lastTimeStamp = link.timestamp;
        return;
    }
    
    NSTimeInterval delta = link.timestamp - _lastTimeStamp;
    //统计一秒内刷新次数
    if (delta < 1) {
        _disPlayCount++;
        return;
        
    } else {
        //计算FPS
        _fps = _disPlayCount / delta;
        _fpsLabel.text = [NSString stringWithFormat:@"FPS:%.0f",_fps];
//        NSLog(@"count = %zd, delta = %f,_lastTime = %f, _fps = %.0f",_count, delta, _lastTimeStamp, _fps);
        
        //重新记录时间戳和刷新次数
        _lastTimeStamp = link.timestamp;
        _disPlayCount = 0;
    }
}


@end
