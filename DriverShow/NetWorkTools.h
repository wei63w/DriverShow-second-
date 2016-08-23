//
//  NetWorkTools.h
//  AFNFZ
//
//  Created by 魏云超 on 16/2/26.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface NetWorkTools : AFHTTPSessionManager

+(instancetype)sharedNetworkTools;

@end
