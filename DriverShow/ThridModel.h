//
//  ThridModel.h
//  DriverShow
//
//  Created by 魏云超 on 16/8/27.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThridModel : NSObject

@property (nonatomic, copy) NSString *kindid;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *ename;

@end


@interface kind : NSObject

@property (nonatomic, copy) NSArray *kind;

@end

@interface ThridData : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) kind *result;

@end