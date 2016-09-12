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
#import "MJRefresh.h"
#import "MBProgressHUD.h"


@interface CenterDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger selectedBandId;
///菜单是否已经弹出
@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) NSArray<Car *> *carLis;

@property (nonatomic, strong) NSMutableArray<Car *> *tbData;


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

@property (nonatomic, assign) BOOL isUpPull;

@end

@implementation CenterDetailViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    //去除cell边框线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    self.isShow = NO;
    self.selectedIndex = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self resetTitle:@"全部车型"];
    
    [self setLeftBarButtonItem];
    [self setRightBarButtonItem];
    
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
        
        self.isUpPull = NO;
        //每次下拉刷新清空上拉加载数据
        self.tbData = [NSMutableArray arrayWithCapacity:10];
        
        [self updateItemCellandPage:0 andSort:self.sort andBrand:self.brand andIsUpPull:NO];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
    }];
    /**
     *  上拉刷新
     */
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.page ++;
        self.isUpPull = YES;
        [self updateItemCellandPage:self.page andSort:self.sort andBrand:self.brand andIsUpPull:YES];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}
-(void)loadNewData{
    [self updateItemCellandPage:self.page andSort:self.sort andBrand:self.brand andIsUpPull:NO];
    
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
/**
 *  下拉刷新cell
 */
-(void)updateItemCellandPage:(NSInteger)page andSort:(NSInteger)sort andBrand:(NSInteger)brand andIsUpPull:(BOOL)isUpPull{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        NSDictionary *parameters = @{@"page":@(page),@"sort":@(sort),@"brand":@(brand)};
        [[NetWorkTools sharedNetworkTools]GET:@"API/Car/rentList" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [CenterModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"result":@"Resultt",
                         };
            }];
           
            CenterModel *centerModel = [CenterModel mj_objectWithKeyValues:responseObject];
            
            if (isUpPull) {//如果是下拉刷新 数据拼接上去
                [self.tbData addObjectsFromArray:self.centerModel.result.car];
                [self.tbData addObjectsFromArray:centerModel.result.car];
            }
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
            
            NSLog(@"失败:%@",error);
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isUpPull) {
        return self.tbData.count;
    }
    return self.centerModel.result.car.count;
    
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
    
    if (self.isUpPull) {
        _carLis = self.tbData;
    }else{
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
    Car *tempCar;
    if (_isUpPull) {
        tempCar =  [Car mj_objectWithKeyValues:_tbData[indexPath.row]];
    }else{
      tempCar = [Car mj_objectWithKeyValues:_carLis[indexPath.row]];
    }
    //要用carid 是brandid
    parameterss = @{@"id":tempCar.carid};
    
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
        LastData *lastdata = [LastData mj_objectWithKeyValues:responseObject];

        if ([lastdata.status isEqualToString:@"-1"]) {
            [self ErrorCustomAlert:@"暂时无改数据,请稍后重试..."];
        }
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SinglePageViewController" bundle:nil];
        SinglePageViewController *vc = sb.instantiateInitialViewController;
        vc.lastModel = lastdata.result;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self ErrorCustomAlert:@"服务器暂无数据,请稍后重试..."];
        NSLog(@"失败:%@",error);
    }];
    
    
    
    
}


-(void)ErrorCustomAlert:(NSString *)errorStr{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okaction];
    [self presentViewController:alertController animated:YES completion:^{
        return ;
        
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
