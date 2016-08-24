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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *RightItem;


@property (weak, nonatomic) IBOutlet UIView *centerContent;

@property (weak, nonatomic) IBOutlet UIView *leftFotter;

@property (weak, nonatomic) IBOutlet UIView *rightFotter;

@property (nonatomic, strong) HeadScrollView *scrollView;

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
    
    [self InitData];
    
    [self createInfiniteScrollView];
    
    
}





-(void)InitData{
    
    [[NetWorkTools sharedNetworkTools]POST:@"API/Car/onePage" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [Starts mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"Result":@"result"
                     };
        }];
        
      
        
        Starts *start = [Starts mj_objectWithKeyValues:responseObject];
       
        self.startModel = start;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:4];
        
            for (NSString *item in self.startModel.result.banner) {
        
                UIImageView *imv = [[UIImageView alloc]init];
        
                [imv sd_setImageWithURL:[NSURL URLWithString:item]
                                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
                                             NSLog(@"ok");
        
                                                }
                 ];
                [arr addObject:imv];
                
            }
        
            self.scrollView.images = arr;
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"失败:%@",error);
    }];
    

    
}



//创建顶部的轮播图
- (void)createInfiniteScrollView {
    
    //44
    self.scrollView = [[HeadScrollView alloc] init];
    
    self.scrollView.frame = CGRectMake(0,64, kDeviceWidth, 250 );
    
    
    

    
    self.scrollView.images =  @[
                          [UIImage imageNamed:@"car1.jpg"],
                          [UIImage imageNamed:@"car2.jpg"],
                          [UIImage imageNamed:@"car3.jpg"],
//                          [UIImage imageNamed:@"car4.jpg"],
                          ];
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
