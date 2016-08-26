//
//  DetailTableViewCell.h
//  DriverShow
//
//  Created by genilex3 on 16/8/26.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCellModel.h"

@interface DetailTableViewCell : UITableViewCell

@property (nonatomic, strong) DetailCellModel *model;

-(void)loadDetailCellWithModel:(DetailCellModel *)model;

+(instancetype)DetailCellCellWithTbleView:(UITableView *)tableView;

@end
