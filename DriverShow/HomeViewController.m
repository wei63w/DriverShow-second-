//
//  HomeViewController.m
//  DriverShow
//
//  Created by genilex3 on 16/8/22.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import "HomeViewController.h"
#import "HeadScrollView.h"
#import "NetWorkTools.h"
#import "CenterDetailViewController.h"
#import "MJExtension.h"
#import "Starts.h"



#define kDeviceWidth [UIScreen mainScreen].bounds.size.width


@interface HomeViewController ()<HeadScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *NavBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *LiftItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *RightItem;


@property (weak, nonatomic) IBOutlet UIView *centerContent;

@property (weak, nonatomic) IBOutlet UIView *leftFotter;

@property (weak, nonatomic) IBOutlet UIView *rightFotter;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    title.text = @"首页";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    self.navigationItem.leftBarButtonItem.title = @"北京";
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];

    
    [self createInfiniteScrollView];
    
    [self getNewWork];
}


-(void)getNewWork{
    [[NetWorkTools sharedNetworkTools]POST:@"API/Car/onePage" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"请求中");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
//        Starts *start = [Starts mj_objectWithKeyValues:responseObject];
        
        Starts *arr = [Starts mj_objectWithKeyValues:responseObject];
        
        
        NSLog(@"成功%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败:%@",error);
    }];
}



//创建顶部的轮播图
- (void)createInfiniteScrollView {
    
    //44
    HeadScrollView *scrollView = [[HeadScrollView alloc] init];
    scrollView.frame = CGRectMake(0,64, kDeviceWidth, 250 );
    scrollView.images = @[
                          [UIImage imageNamed:@"car1.jpg"],
                          [UIImage imageNamed:@"car2.jpg"],
                          [UIImage imageNamed:@"car3.jpg"],
                          [UIImage imageNamed:@"car4.jpg"],
                          ];
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    scrollView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
}


#pragma mark - HeadScrollViewDelegate -
// 如果不想实现直接去掉此方法即可
- (void)ScrollViewDidClickAtAnyImageView:(UIImageView *)imageView {
    
    NSLog(@"%ld --  %@",imageView.tag, imageView.image);
}

//centerView Click
- (IBAction)centerBtnClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CenterDetail" bundle:nil];
    CenterDetailViewController *vc = sb.instantiateInitialViewController;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)leftBtnClick:(id)sender {
    
    
}


- (IBAction)rightBtnClick:(id)sender {
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
