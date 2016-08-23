//
//  WYCAdvert.h
//  TotalTest
//
//  Created by genilex3 on 16/7/21.
//  Copyright © 2016年 wei63w. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adUrl";

@interface WYCAdvert : UIView

/**
 *  显示广告
 */
-(void)ShowAdvert;

/**
 *  图片路径
 */
@property (nonatomic, copy) NSString *filePath;

@end
