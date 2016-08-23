//
//  NSString+Path.h
//  AFNFZ
//
//  Created by 魏云超 on 16/2/26.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)

///  拼接文档目录
- (NSString *)appendDocumentPath;
///  拼接缓存目录
- (NSString *)appendCachePath;
///  拼接临时目录
- (NSString *)appendTempPath;

@end
