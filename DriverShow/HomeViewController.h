//
//  HomeViewController.h
//  DriverShow
//
//  Created by genilex3 on 16/8/22.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Starts.h"


@interface HomeViewController : UIViewController


@property (nonatomic, strong) Starts *startModel;

@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;

@end
