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


@interface CenterDetailViewController ()<UITableViewDelegate,UITableViewDataSource>


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
    
    
        UIButton *title = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        [title setTitle:@"全部车型" forState:UIControlStateNormal];
        [title addTarget:self action:@selector(labelTap) forControlEvents:UIControlEventTouchUpInside];
        [title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.navigationItem.titleView = title;
    
//      self.navigationItem.leftBarButtonItem.title = @"aa";
    
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
    
    NSArray<Brand *> *brandLis = self.centerModel.result.brand;
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
    
    
//    NSDictionary *parameters = @{@"receive":@"first"};
//    [[NetWorkTools sharedNetworkTools]GET:@"API/Car/receiveData" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//       
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        NSLog(@"失败:%@",error);
//    }];
//    
    [self.view addSubview:self.maskView];
    
    
}

-(void)chooseSeriase:(id)btn{
    CustomButton *tempBtn = (CustomButton *)btn;
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
    if (self.selectedBandId == 0 || self.selectedBandId == nil) {
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
    if (self.selectedBandId == 0 || self.selectedBandId == nil) {
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
