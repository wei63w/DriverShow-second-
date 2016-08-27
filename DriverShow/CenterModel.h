//
//  CenterModel.h
//  DriverShow
//
//  Created by 魏云超 on 16/8/27.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Brand:NSObject

@property (nonatomic, copy) NSString *brandid;
@property (nonatomic, copy) NSString *brandname;

@end

@interface Car:NSObject
@property (nonatomic, copy) NSString *carid;
@property (nonatomic, copy) NSString *carbrand;
@property (nonatomic, copy) NSString *isdiscount;
@property (nonatomic, copy) NSString *carname;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *weeksprice;

@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *price;
@end

@interface Resultt:NSObject
@property (nonatomic, strong) NSArray *brand;
@property (nonatomic, strong) NSArray *car;
@end


@interface CenterModel : NSObject



@property (nonatomic, strong) Resultt *result;

@property (nonatomic, copy) NSString *status;

@end
