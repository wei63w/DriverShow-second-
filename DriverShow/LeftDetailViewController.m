//
//  LeftDetailViewController.m
//  DriverShow
//
//  Created by 魏云超 on 16/8/27.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import "LeftDetailViewController.h"
#import "LeftDetailTableViewCell.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "NetWorkTools.h"
#import "CustomButton.h"
#import "LeftSingleViewController.h"
#import "LeftSingleModel.h"


@interface LeftDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger selectedBandId;
///菜单是否已经弹出
@property (nonatomic, assign) BOOL isShow;

/**
 *  页码
 */
@property (nonatomic, assign) NSInteger page;
/**
 *  是否排序  1,2 升序,降序
 */
@property (nonatomic, assign) NSInteger sort;
/**
 *  系列Id
 */
@property (nonatomic, assign) NSInteger brand;

@end

@implementation LeftDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setLeftBarButtonItem];
    [self setRightBarButtonItem];
    self.isShow = NO;
    self.selectedIndex = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self resetTitle:@"婚车精选"];
    
    self.page  = 0;
    self.sort = 1;
    self.brand = 0;
    
    //setRefresh
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    /**
     *  下拉刷新
     */
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSLog(@"%ld",self.brand);
        [self updateItemCellandPage:0 andSort:self.sort andBrand:self.brand];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
    }];
    /**
     *  上拉刷新
     */
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.page ++;
        
        [self updateItemCellandPage:self.page andSort:self.sort andBrand:self.brand];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
}


-(void)setRightBarButtonItem{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 24, 28);
    [rightBtn addTarget:self action:@selector(rightBarTouch) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"rightBarBg"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
/**
 *  排序
 */
-(void)rightBarTouch{
    if (self.sort == 1) {
        self.sort = 2;
    }else{
        self.sort = 1;
    }
    //   [self updateItemCellandPage:self.page andSort:self.sort andBrand:self.brand];
    [self.tableView.mj_header beginRefreshing];
}
-(void)labelTap{
    NSLog(@"点击标题");
    
    if (self.isShow == YES) {
        [self.maskView removeFromSuperview];
        self.isShow = NO;
        return;
    }
    
    
    self.isShow = YES;
    CGRect rec = self.view.frame;
    rec.origin.y += 60;
    self.maskView = [[UIView alloc]initWithFrame:rec];
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    int totalloc=3;
    CGFloat appvieww=100;
    CGFloat appviewh=50;
    
    CGFloat margin=(self.maskView.frame.size.width-totalloc*appvieww)/(totalloc+1);
    
    NSInteger count = self.centerModel.result.brand.count;
    for (int i=0; i<count; i++) {
        
        [Brand mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"brandname" : @"name",
                     @"brandid" : @"id",
                     };
        }];
        
        Brand *brand = [Brand mj_objectWithKeyValues:self.centerModel.result.brand[i]];
        int row=i/totalloc;//行号
        //1/3=0,2/3=0,3/3=1;
        int loc=i%totalloc;//列号
        
        CGFloat appviewx=margin+(margin+appvieww)*loc;
        CGFloat appviewy=margin+(margin+appviewh)*row;
        //创建uiview控件
        UIView *appview=[[UIView alloc]initWithFrame:CGRectMake(appviewx, appviewy, appvieww, appviewh)];
        
        //        [appview setBackgroundColor:[UIColor purpleColor]];
        
        
        CustomButton *btn = [[CustomButton alloc]initWithFrame:CGRectMake(0, 0, appvieww, appviewh)];
        [btn setTitle:brand.brandname forState:UIControlStateNormal];
        btn.brandName = brand.brandname;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.brandid = [brand.brandid intValue];
        btn.tag = i;
        [btn addTarget:self action:@selector(chooseSeriase:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [appview addSubview:btn];
        
        if (i == self.selectedIndex) {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, appvieww, 5)];
            [lab setBackgroundColor:[UIColor colorWithRed:150/255.0 green:125/255.0 blue:79/255.0 alpha:1]];
            [appview addSubview:lab];
        }
        [self.maskView addSubview:appview];
    }
    [self.view addSubview:self.maskView];
}


//选中标题系列
-(void)chooseSeriase:(id)btn{
    
    CustomButton *tempBtn = (CustomButton *)btn;
    //重新设置标题 tempBtn.brandName
    [self resetTitle:tempBtn.brandName];
    
    self.selectedIndex = tempBtn.tag;
    self.selectedBandId = tempBtn.brandid;
    
    self.page = 0;
    self.sort = 1;
    self.brand = tempBtn.brandid;
    [self.tableView.mj_header beginRefreshing];
    self.isShow = NO;
    [self.maskView removeFromSuperview];
}

//重新设置标题
-(void)resetTitle:(NSString *)str{
    //重新设置标题
    UIView *tempTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    UIButton *title = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    UIImage *img = [UIImage imageNamed:@"downArrow"];
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(90, 3, 20, 20)];
    imgv.image = img;
    
    [title setTitle:str forState:UIControlStateNormal];
    [title addTarget:self action:@selector(labelTap) forControlEvents:UIControlEventTouchUpInside];
    [title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [tempTitleView addSubview:title];
    [tempTitleView addSubview:imgv];
    self.navigationItem.titleView = tempTitleView;
}




-(void)loadNewData{
    [self updateItemCellandPage:self.page andSort:self.sort andBrand:self.brand];
    
}
/**
 *  下拉刷新cell
 */
-(void)updateItemCellandPage:(NSInteger)page andSort:(NSInteger)sort andBrand:(NSInteger)brand{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        NSDictionary *parameters = @{@"page":@(page),@"sort":@(sort),@"brand":@(brand)};
        [[NetWorkTools sharedNetworkTools]GET:@"API/Car/weddingList" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [CenterModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"result":@"Resultt",
                         };
            }];
            
            CenterModel *centerModel = [CenterModel mj_objectWithKeyValues:responseObject];
            
            if ([centerModel.status isEqualToString:@"-1"]) {
                //没有更多数据了
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                return;
            }else{
                self.centerModel = centerModel;
                self.page = page;
                self.sort = sort;
                self.brand = brand;
                [self.tableView reloadData];
                // 结束刷新
                [self.tableView.mj_footer endRefreshing];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"失败:%@",error);
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}



-(void)setLeftBarButtonItem{
    // need delegate can right swipe -->UIGestureRecognizerDelegate
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
    imgv.image = [UIImage imageNamed:@"leftArrow"];
    [backBtn addSubview:imgv];
    
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

-(void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.centerModel.result.car.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    LeftDetailTableViewCell   *cell = [LeftDetailTableViewCell DetailCellWithTbleView:tableView];
    
    [Car mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"carid":@"id",
                 @"carname":@"name",
                 @"carbrand":@"brand"
                 };
    }];
    
    Car *tempCar = [Car mj_objectWithKeyValues:self.centerModel.result.car[indexPath.row]];
    
    
    
    DetailCellModel *model = [[DetailCellModel alloc]init];
    model.imgStr = tempCar.pic;
    model.carName = tempCar.carname;
    model.money = tempCar.price;
    cell.model = model;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Car *tempCar = [Car mj_objectWithKeyValues:self.centerModel.result.car[indexPath.row]];
    DetailCellModel *model = [[DetailCellModel alloc]init];
    model.imgStr = tempCar.pic;
    model.carName = tempCar.carname;
    model.money = tempCar.price;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        NSLog(@"%@",tempCar.carbrand);
        NSDictionary *parameters = @{@"id":tempCar.carbrand};
        [[NetWorkTools sharedNetworkTools]GET:@"API/Car/weddingDetail" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [LeftSingleData mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"carid":@"id"
                         };
            }];
            [LeftSingleModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"result":@"LeftSingleData",
                         };
            }];
             LeftSingleModel *leftSingleModel = [LeftSingleModel mj_objectWithKeyValues:responseObject];
            
            if ([leftSingleModel.status isEqualToString:@"-1"]) {
              UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂无该车信息,详情请联系客服人员" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"客服咨询" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"18611983873"];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }];
                [alertController addAction:cancleAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:^{
                    return ;
                }];
                
            }
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LeftSingleViewController" bundle:nil];
            LeftSingleViewController *vc = sb.instantiateInitialViewController;
            vc.leftSingle = leftSingleModel.result;
            [self.navigationController pushViewController:vc animated:YES];
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"失败:%@",error);
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });

    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
