//
//  LeftDetailTableViewCell.h
//  DriverShow
//
//  Created by 魏云超 on 16/8/27.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCellModel.h"



@interface LeftDetailTableViewCell : UITableViewCell


@property (nonatomic, strong) DetailCellModel *model;

+(instancetype)DetailCellWithTbleView:(UITableView *)tableView;
@end
