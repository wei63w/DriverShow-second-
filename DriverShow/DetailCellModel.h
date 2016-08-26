//
//  DetailCellModel.h
//  DriverShow
//
//  Created by genilex3 on 16/8/26.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailCellModel : NSObject


@property (nonatomic, copy) NSString *imgName;

/**
 *  名称
 */
@property (nonatomic, copy) NSString *carName;
/**
 *  价格
 */
@property (nonatomic, copy) NSString *money;
/**
 *  方式
 */
@property (nonatomic, copy) NSString *toWay;

@end
