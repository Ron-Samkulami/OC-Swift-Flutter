//
//  NSDate+RSFormat.m
//  TEST
//
//  Created by 111 on 2021/12/20.
//

#import "NSDate+RSFormat.h"

@implementation NSDate (RSFormat)


+ (NSString *)currentDate{
    
    //获取系统时间戳
    NSDate* date1 = [NSDate date];
    NSTimeInterval time1 =[date1 timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f",time1];
    
    //时间戳转换成时间
    NSTimeInterval time2 =[timeString doubleValue];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:time2];

    //显示的时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentTime = [formatter stringFromDate:date2];
    
    return currentTime;
}
@end
