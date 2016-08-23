//
//  NSString+Path.m
//  AFNFZ
//
//  Created by 魏云超 on 16/2/26.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import "NSString+Path.h"
//添加类别类 继承NSString
@implementation NSString (Path)

- (NSString *)appendDocumentPath {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)appendCachePath {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)appendTempPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:self.lastPathComponent];
}


@end
