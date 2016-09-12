//
//  LeftSingleModel.h
//  DriverShow
//
//  Created by genilex3 on 16/9/12.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LeftSingleData : NSObject

@property (nonatomic, copy) NSString *carid;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *wid;

@end

@interface LeftSingleModel : NSObject

@property (nonatomic, strong) LeftSingleData *result;
@property (nonatomic, copy) NSString *status;

@end
