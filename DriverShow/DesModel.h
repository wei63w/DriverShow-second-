//
//  DesModel.h
//  DriverShow
//
//  Created by 魏云超 on 16/8/27.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *min_title;
@property (nonatomic, copy) NSString *mid_title;
@property (nonatomic, copy) NSString *max_title;
@property (nonatomic, copy) NSString *min_des;
@property (nonatomic, copy) NSString *mid_des;
@property (nonatomic, copy) NSString *max_des;
@end

@interface DesData:NSObject
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) DesModel *result;
@end