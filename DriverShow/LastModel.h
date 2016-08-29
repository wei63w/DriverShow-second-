//
//  LastModel.h
//  DriverShow
//
//  Created by 魏云超 on 16/8/28.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LastModel : NSObject

@property (nonatomic, copy) NSString *lastid;
@property (nonatomic, copy) NSString *rentid;
@property (nonatomic, copy) NSString *dayprice;
@property (nonatomic, copy) NSString *weekprice;
@property (nonatomic, copy) NSString *monthprice;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *colour;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *name;
@end

@interface LastData : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) LastModel *result;

@end