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
#import "CenterModel.h"
#import "LeftDetailViewController.h"
#import "RightDetailViewController.h"
#import "ThridModel.h"
#import "UILabel+CustomLabel.h"

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
    
    [self setLaunch];
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:1/255.0 alpha:1];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    title.text = @"";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    
    
    
    UIBarButtonItem *bb = [[UIBarButtonItem alloc]initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(leftTouch)];
    self.navigationItem.leftBarButtonItem = bb;
   
    
    
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.NavBar.title = @"";
    
    
    
    [self InitData];
    [self createInfiniteScrollView];
    [self setViewImage];
    
    
 
}
-(void)setLaunch{
//    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    
//    UIView *launchView = viewController.view;
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    
//    launchView.frame = [UIApplication sharedApplication].keyWindow.frame;
//    [mainWindow addSubview:launchView];
    UIImageView *templaunch = [[UIImageView alloc]initWithFrame:mainWindow.frame];
    templaunch.image = [UIImage imageNamed:@"Default"];
    
    [mainWindow addSubview:templaunch];
    
    
    [UIView animateWithDuration:0.6f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        launchView.alpha = 0.0f;
//        launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5f, 1.5f, 1.0f);
        templaunch.alpha = 0.0f;
        templaunch.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5f, 1.5f, 1.0f);
        
    } completion:^(BOOL finished) {
//        [launchView removeFromSuperview];
        [templaunch removeFromSuperview];
    }];
}
-(void)leftTouch{
    NSLog(@"嘿嘿嘿");
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
                      placeholderImage:[UIImage imageNamed:@"defaultPic"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            }
     ];
    self.centerOneLab.text = self.startModel.result.oneename;
//    [self.centerOneLab setCustomerAttributeTest:self.startModel.result.oneename];
    [self.centerTwoLab setCustomerAttributeTest:self.startModel.result.onecname];
//    [self.leftOneLab setCustomerAttributeTest:self.startModel.result.secondename];
    self.leftOneLab.text = self.startModel.result.secondename;
    [self.leftTwoLab setCustomerAttributeTest:self.startModel.result.secondcname];
//    [self.rightOneLab setCustomerAttributeTest:self.startModel.result.thirdename];
    self.rightOneLab.text = self.startModel.result.thirdename;
    [self.rightTwoLab setCustomerAttributeTest:self.startModel.result.thirdcname];
    
    
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:self.startModel.result.secondpic]
                      placeholderImage:[UIImage imageNamed:@"defaultPic"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             }
     ];
    [self.rightImg sd_setImageWithURL:[NSURL URLWithString:self.startModel.result.thirdpic]
                      placeholderImage:[UIImage imageNamed:@"defaultPic"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             }
     ];
    
}


-(void)InitData{
    NSString *urlStr = @"http://muxinzuche.com/API/Car/onePage";
    
    NSData *resultData = [self asyndNetRequest:urlStr];
    [Starts mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"Result":@"result"
                 };
    }];
    Starts *start = [Starts mj_objectWithKeyValues:resultData];
    self.startModel = start;
}

-(NSData *)asyndNetRequest:(NSString *)urlStr{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"GET";
    
    
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlrequest returningResponse:&response error:&error];
    if (error == nil) {//成功
        return data;
    }else{
        NSLog(@"错误:%@",error);
        return nil;
    }
}

//创建顶部的轮播图
- (void)createInfiniteScrollView {
    
    //44
    self.scrollView = [[HeadScrollView alloc] init];
    
    self.scrollView.frame = CGRectMake(0,64, kDeviceWidth, 250 );
    self.scrollView.images = self.startModel.result.banner;
    self.scrollView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.scrollView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}


#pragma mark - HeadScrollViewDelegate -
// 如果不想实现直接去掉此方法即可
- (void)ScrollViewDidClickAtAnyImageView:(UIImageView *)imageView {
    
//    NSLog(@"%ld --  %@",imageView.tag, imageView.image);
}

//centerView Click
- (IBAction)centerBtnClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CenterDetail" bundle:nil];
    CenterDetailViewController *vc = sb.instantiateInitialViewController;

//    NSDictionary *parameters = @{@"receive":@"first"};
//    [[NetWorkTools sharedNetworkTools]GET:@"API/Car/receiveData" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        [CenterModel mj_setupObjectClassInArray:^NSDictionary *{
//            return @{
//                     @"result":@"Resultt",
//                     };
//        }];
    
//        CenterModel *centerModel = [CenterModel mj_objectWithKeyValues:responseObject];
    
        vc.centerModel = nil;//centerModel;

        [self.navigationController pushViewController:vc animated:YES];
        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        NSLog(@"失败:%@",error);
//    }];
    
}

- (IBAction)leftBtnClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LeftDetailViewController" bundle:nil];
    LeftDetailViewController *vc = sb.instantiateInitialViewController;
//    NSDictionary *parameters = @{@"receive":@"second"};
//    [[NetWorkTools sharedNetworkTools]GET:@"API/Car/receiveData" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        [CenterModel mj_setupObjectClassInArray:^NSDictionary *{
//            return @{
//                     @"result":@"Resultt",
//                     };
//        }];
//        
//        CenterModel *centerModel = [CenterModel mj_objectWithKeyValues:responseObject];
        vc.centerModel = nil;// centerModel;
        
        
        [self.navigationController pushViewController:vc animated:YES];
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        NSLog(@"失败:%@",error);
//    }];
    
    
    
}


- (IBAction)rightBtnClick:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RightDetailViewController" bundle:nil];
    RightDetailViewController *vc = sb.instantiateInitialViewController;
    
    NSDictionary *parameters = @{@"receive":@"third"};
    [[NetWorkTools sharedNetworkTools]GET:@"API/Car/receiveData" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        
        [ThridData mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"kind":@"kind",
                     };
        }];
        
        ThridData *thridData = [ThridData mj_objectWithKeyValues:responseObject];
        vc.thridData = thridData;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"失败:%@",error);
    }];
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
