//
//  SeriaceModel.h
//  DriverShow
//
//  Created by genilex3 on 16/9/8.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface seriaceData:NSObject
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *resultid;
@property (nonatomic, copy) NSString *isdiscount;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *weeksprice;
@end


@interface SeriaceModel : NSObject

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, copy) NSString *status;


@end
