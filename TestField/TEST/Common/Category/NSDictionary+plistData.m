//
//  NSDictionary+plistData.m
//  TEST
//
//  Created by 111 on 2021/12/21.
//

#import "NSDictionary+plistData.h"

@implementation NSDictionary (plistData)

+ (NSDictionary *)getDataFormPlist:(NSString *)plist {
    NSString *url = [[NSBundle mainBundle] pathForResource:plist ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:url];
    
    return dict;
}
@end
