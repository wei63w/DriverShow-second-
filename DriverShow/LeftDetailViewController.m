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


@interface LeftDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation LeftDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setLeftBarButtonItem];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    title.text = @"婚庆租车";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
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
