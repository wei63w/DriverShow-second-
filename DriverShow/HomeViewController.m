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
#import <SDWebImage/UIImageView+WebCache.h>

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width


@interface HomeViewController ()<HeadScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *NavBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *LiftItem;

@property (weak, nonatomic) IBOutlet UIImageView *centerImg;

@property (weak, nonatomic) IBOutlet UIImageView *rightImg;

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;

@property (nonatomic, strong) HeadScrollView *scrollView;
@property (nonatomic, strong) NSArray *imgArr;

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
    
    self.NavBar.title = @"";
    
    
    
    [self InitData];
    [self createInfiniteScrollView];
    [self setViewImage];
    
    
 
}





-(void)InitData2{
    [[NetWorkTools sharedNetworkTools]POST:@"API/Car/onePage" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"失败:%@",error);
    }];
}

-(void)setViewImage{
    
    [self.centerImg sd_setImageWithURL:[NSURL URLWithString:self.startModel.result.onepic]
                      placeholderImage:[UIImage imageNamed:@"placeholder"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            }
     ];
    
    self.centerOneLab.text = self.startModel.result.oneename;
    self.centerTwoLab.text = self.startModel.result.onecname;
    self.leftOneLab.text = self.startModel.result.secondename;
    self.leftTwoLab.text = self.startModel.result.secondcname;
    self.rightOneLab.text = self.startModel.result.thirdename;
    self.rightTwoLab.text = self.startModel.result.thirdcname;
    
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:self.startModel.result.secondpic]
                      placeholderImage:[UIImage imageNamed:@"placeholder"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             }
     ];
    [self.rightImg sd_setImageWithURL:[NSURL URLWithString:self.startModel.result.thirdpic]
                      placeholderImage:[UIImage imageNamed:@"placeholder"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             }
     ];
    
}


-(void)InitData{
    NSString *urlStr = @"http://muxinzuche.com/API/Car/onePage";
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"POST";
   
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlrequest returningResponse:&response error:&error];
    
    if (error == nil) {//成功
        [Starts mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"Result":@"result"
                     };
        }];
        Starts *start = [Starts mj_objectWithKeyValues:data];
        self.startModel = start;
        
    }else{
        NSLog(@"错误:%@",error);
    }
}



//创建顶部的轮播图
- (void)createInfiniteScrollView {
    
    //44
    self.scrollView = [[HeadScrollView alloc] init];
    
    self.scrollView.frame = CGRectMake(0,64, kDeviceWidth, 250 );
//    self.scrollView.images =  @[
//                          [UIImage imageNamed:@"car1.jpg"],
//                          [UIImage imageNamed:@"car2.jpg"],
//                          [UIImage imageNamed:@"car3.jpg"],
//                          [UIImage imageNamed:@"car4.jpg"],
//                          ];
    self.scrollView.images = self.startModel.result.banner;
    self.scrollView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.scrollView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
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
    
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//    title.text = @"全部车型";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    vc.navigationItem.titleView = title;
    
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)leftBtnClick:(id)sender {
    
    
}


- (IBAction)rightBtnClick:(id)sender {
}




#pragma mark  lazy



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
