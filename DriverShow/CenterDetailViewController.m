//
//  CenterDetailViewController.m
//  DriverShow
//
//  Created by 魏云超 on 16/8/23.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import "CenterDetailViewController.h"
#import "DetailTableViewCell.h"
#import "MJExtension.h"
#import "CustomButton.h"
#import "NetWorkTools.h"
#import "LastModel.h"
#import "SinglePageViewController.h"


@interface CenterDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger selectedBandId;
///菜单是否已经弹出
@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) NSArray<Car *> *carLis;

@end

@implementation CenterDetailViewController

- (void)viewDidLoad {
    
    
    
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isShow = NO;
    self.selectedIndex = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self resetTitle:@"全部车型"];
    
    [self setLeftBarButtonItem];
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



//选中标题系列
-(void)chooseSeriase:(id)btn{
    CustomButton *tempBtn = (CustomButton *)btn;
    
    //重新设置标题 tempBtn.brandName
    [self resetTitle:tempBtn.brandName];
    
    
    
    
    self.selectedIndex = tempBtn.tag;
    self.selectedBandId = tempBtn.brandid;
    NSMutableArray<Car *> *tempLis = [NSMutableArray arrayWithCapacity:10];
    
    for (Car *model in self.centerModel.result.car) {
        Car *tempModel = [Car mj_objectWithKeyValues:model];
        if (tempBtn.brandid == [tempModel.carbrand intValue]) {
            [tempLis addObject:tempModel];
        }
    }
    self.carLis = tempLis;
    [self.tableView reloadData];
    self.isShow = NO;
    [self.maskView removeFromSuperview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.selectedBandId == 0 || self.selectedBandId == 1) {
        return self.centerModel.result.car.count;
    }else{
        NSInteger temIndex = 0;
        for (Car *model in _carLis) {
            Car *tempModel = [Car mj_objectWithKeyValues:model];
            if (self.selectedBandId == [tempModel.carbrand intValue]) {
                temIndex ++;
            }
        }
        
        return temIndex;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
     DetailTableViewCell   *cell = [DetailTableViewCell DetailCellWithTbleView:tableView];
    
     [Car mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
         return @{
                  @"carid":@"id",
                  @"carname":@"name",
                  @"carbrand":@"brand"
                  };
     }];
    if (self.selectedBandId == 0 || self.selectedBandId == 1) {
        _carLis = self.centerModel.result.car;
    }
    
    Car *tempCar = [Car mj_objectWithKeyValues:_carLis[indexPath.row]];
    
    
    
    DetailCellModel *model = [[DetailCellModel alloc]init];
    model.imgStr = tempCar.picture;
    model.carName = tempCar.carname;
    model.money = tempCar.weeksprice;
    model.toWay = @"按月:面议";
    
    cell.model = model;
    
    return cell;
}

NSDictionary *parameterss;
//选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [Car mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"carid":@"id",
                 @"carname":@"name",
                 @"carbrand":@"brand"
                 };
    }];
     Car *tempCar = [Car mj_objectWithKeyValues:_carLis[indexPath.row]];
     NSLog(@"%@",tempCar.carbrand);
    
    parameterss = @{@"id":@"39"};
    
    NSLog(@"%@",parameterss);
    [[NetWorkTools sharedNetworkTools]GET:@"API/Car/rentDetail" parameters:parameterss progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [LastModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"lastid":@"id"
                     };
        }];
        [LastData mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"result":@"LastModel",
                     };
        }];
        LastData *lastdata = [LastData mj_objectWithKeyValues:responseObject];;
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SinglePageViewController" bundle:nil];
        SinglePageViewController *vc = sb.instantiateInitialViewController;
        vc.lastModel = lastdata.result;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    
        NSLog(@"失败:%@",error);
    }];
    
    
    
    
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
