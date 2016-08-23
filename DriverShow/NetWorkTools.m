//
//  NetWorkTools.m
//  AFNFZ
//
//  Created by 魏云超 on 16/2/26.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import "NetWorkTools.h"
/**
 *  1.建立一个网络管理单例,统一管理所有网络请求
 */
@implementation NetWorkTools

+(instancetype)sharedNetworkTools{
    static NetWorkTools *tools;
    static dispatch_once_t onceToken;
    
    
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURL *baseURL = [NSURL URLWithString:@"http://muxinzuche.com/"];
        
        tools.securityPolicy.allowInvalidCertificates = YES;
//        [tools.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        tools.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        tools = [[self alloc]initWithBaseURL:baseURL sessionConfiguration:config];
    });
    return tools;
}

@end
