//
//  NSDictionary+plistData.h
//  TEST
//
//  Created by 111 on 2021/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (plistData)

+ (NSDictionary *)getDataFormPlist:(NSString *)plist;

@end

NS_ASSUME_NONNULL_END
