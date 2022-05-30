//
//  UserDataCenter.m
//  TEST
//
//  Created by 111 on 2021/7/27.
//

#import "UserDataCenter.h"

static UserDataCenter *static_UserDataCenter;

@interface UserDataCenter ()
@property (nonatomic, strong) dispatch_queue_t concurrent_queue;//并发队列
@property (nonatomic, strong) NSMutableDictionary *userCenterDict;//可变字典
@end

@implementation UserDataCenter

+ (instancetype)sharedUserDataCenter {
    if (static_UserDataCenter == nil) {
        static_UserDataCenter = [[UserDataCenter alloc] init];
    }
    return static_UserDataCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 创建并发队列
        self.concurrent_queue = dispatch_queue_create("read_write_queue", DISPATCH_QUEUE_CONCURRENT);
        // 创建数据容器
        self.userCenterDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)objectForKey:(NSString *)key
{
    __block id obj;
    // 同步读取指定数据
    dispatch_sync(self.concurrent_queue, ^{
        obj = [self.userCenterDict objectForKey:key];
    });
    
    return obj;
}

- (void)setObject:(id)obj forKey:(NSString *)key
{
    key = [key copy];
    // 异步栅栏调用设置数据
    dispatch_barrier_async(_concurrent_queue, ^{
        [self->_userCenterDict setObject:obj forKey:key];
    });
}
@end
