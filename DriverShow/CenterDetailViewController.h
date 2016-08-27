//
//  CenterDetailViewController.h
//  DriverShow
//
//  Created by 魏云超 on 16/8/23.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCellModel.h"
#import "CenterModel.h"

@interface CenterDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CenterModel *centerModel;


@end
