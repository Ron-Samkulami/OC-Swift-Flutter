//
//  GCDTestVC.m
//  TEST
//
//  Created by mige on 2022/5/16.
//

#import "GCDTestVC.h"

@interface GCDTestVC ()

@end

@implementation GCDTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(50,100,300,30)];
    [button1 setTitle:@"测试1" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(onTestBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(50,250,300,30)];
    [button2 setTitle:@"测试2" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(onTestBtn2Action:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - testAction

- (void)onTestBtnAction:(UIButton *)btn {
    
}

- (void)onTestBtn2Action:(UIButton *)btn {
    //批量顺序执行异步任务
    [self doLinarBatchAsyncTaskWithTaskCount:100 beforeTask:^(NSInteger currentIndex) {
        [self logTaskMsg:currentIndex isFinish:NO];
        
    } task:^(NSInteger currentIndex, void (^taskCallback)(void)) {
        //单个子任务详情
        [self asyncTimeConsumeActionWithBlock:^(int timeDelay) {
            //...处理结果
            [self logTaskMsg:currentIndex isFinish:YES];
            //最终调用 taskCallbackBlock
            if (taskCallback) taskCallback();
        }];
        
    } complete:^{
        NSLog(@"任务执行完成");
        [self toast:@"任务执行完成"];
    }];
    
}

#pragma mark - 异步耗时操作
/**
 顺序执行完
 */
- (void)asyncTimeConsumeBatchTask1 {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("myQueue1", DISPATCH_QUEUE_CONCURRENT);//或者在全局队列
    
    //创建异步调度组任务
    dispatch_group_async(group, queue, ^{
        //核心逻辑，一系列子任务，用信号量保证按顺序执行
        for (int i = 0; i < 30; i++) {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            [self logTaskMsg:i isFinish:NO];
            [self asyncTimeConsumeActionWithBlock:^(int timeDelay) {
                [self logTaskMsg:i isFinish:YES];
                dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        
    });
    
    //调度组任务完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"任务执行完成");
    });
}

/**
 方案二 自建并行队列，异步添加任务，任务执行时线程锁
 */
- (void)asyncTimeConsumeBatchTask2 {
    //1、创建子队列进行操作，或者在全局队列中
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    //2、往线程中添加一个大任务
    dispatch_async(queue, ^{
        //2.1 这里是一系列子任务，用信号量保证按顺序执行
        for (int i = 0; i < 100; i++) {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            [self logTaskMsg:i isFinish:NO];
            [self asyncTimeConsumeActionWithBlock:^(int timeDelay) {
                [self logTaskMsg:i isFinish:YES];
                dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        //2.2 这里作为最后一个子任务
        NSLog(@"任务执行完成");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self toast:@"任务执行完成"];
        });
        
    });
    
}

/// 顺序执行一系列异步任务（按顺序回调）
/// @param task 每个异步任务的具体内容，任务完成时必须调用taskCallback()
/// @param taskCount 任务总数
/// @param complete 所有任务完成的回调
- (void)doLinarBatchAsyncTaskWithTaskCount:(NSInteger)taskCount beforeTask:(void (^)(NSInteger currentIndex))actionBeforeTask task:(void (^)(NSInteger currentIndex ,void(^taskCallback)(void)))task complete:(void (^)(void))complete {
    //创建子队列（或者用全局队列）
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    
    //往队列中中添加一个大任务
    dispatch_async(queue, ^{
        //执行一系列子任务，用信号量保证按顺序执行
        for (int idx = 0; idx < taskCount; idx++) {
            //任务前的准备
            if (actionBeforeTask) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    actionBeforeTask(idx);
                });
            }
            //加线程锁
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            //解开线程锁，传入的actionBlock中必须调用一次taskCallback
            void(^taskCallback)(void) = ^() {
                dispatch_semaphore_signal(sema);
            };
            if (task) task(idx,taskCallback);
            
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        
        //完成所有子任务后的操作
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) complete();
        });
        
    });
}

#pragma mark - 同步耗时操作
/**
 方案1 NSOperationQueue设置依赖
 */
- (void)syncTimeConsumeBatchTask1 {
    
    int count = 100;
    NSOperationQueue *operQueue = [[NSOperationQueue alloc] init];
//    [operQueue setMaxConcurrentOperationCount:10]; //设置了线性任务依赖，并发数已经没有意义了
    NSMutableArray <NSOperation *>* taskArr = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        //将任务包装成operation
        NSBlockOperation *oper = [NSBlockOperation blockOperationWithBlock:^{
            [self logTaskMsg:i isFinish:NO];
            [self syncTimeConsumeActionWithBlock:^{
                [self logTaskMsg:i isFinish:YES];
            }];
        }];
        taskArr[i] = oper;
        //每个任务都依赖前一个任务
        if (i > 0 && taskArr[i-1] != nil) {
            [oper addDependency:taskArr[i-1]];
        }
        //添加到任务队列
        [operQueue addOperation:oper];
    }
    
    //添加总结任务
    NSBlockOperation *finishOper = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务执行完成");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self toast:@"任务执行完成"];
        });
    }];
    [finishOper addDependency:taskArr.lastObject];
    [operQueue addOperation:finishOper];
    
}


#pragma mark - common method

/// 模拟同步耗时操作
- (void)syncTimeConsumeActionWithBlock:(void (^)(void))block {
    sleep(1);
    if (block) block();
}

/// 模拟异步耗时操作(网络请求)（延时是延迟将任务放入队列，并不是延迟执行）
- (void)asyncTimeConsumeActionWithBlock:(void (^)(int timeDelay))complete {
    int timeDelay = arc4random_uniform(3)+1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (complete) {
            complete(timeDelay);
        }
    });
}

/// 打印任务状态
- (void)logTaskMsg:(NSInteger)index isFinish:(BOOL)isFinish {
    NSString *status = isFinish ? @"----Done" : @"...";
    NSString *msg = [NSString stringWithFormat:@"Task %zd%@",index,status];
    NSLog(@"%@", msg);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self toast:msg];
    });
}
@end
