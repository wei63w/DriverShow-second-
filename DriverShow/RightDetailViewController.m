//
//  RightDetailViewController.m
//  DriverShow
//
//  Created by 魏云超 on 16/8/27.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import "RightDetailViewController.h"
#import "MJExtension.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "NetWorkTools.h"
#import "DesModel.h"
#import "DetailPageViewController.h"

@interface RightDetailViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *one;

@property (weak, nonatomic) IBOutlet UIView *two;
@property (weak, nonatomic) IBOutlet UIView *three;
@property (weak, nonatomic) IBOutlet UIView *four;
@property (weak, nonatomic) IBOutlet UIView *five;
@property (weak, nonatomic) IBOutlet UIView *six;





@end

@implementation RightDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    title.text = @"场景租车";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    
//    for (id item in self.thridData.result.kind) {
//        
//        ThridModel *model =[ThridModel mj_objectWithKeyValues:item];
//        
//    }
 
    [self loadData:self.one andCurrentIndex:0];
    [self loadData:self.two andCurrentIndex:1];
    [self loadData:self.three andCurrentIndex:2];
    [self loadData:self.four andCurrentIndex:3];
    [self loadData:self.five andCurrentIndex:4];
    [self loadData:self.six andCurrentIndex:5];
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

-(void)loadData:(UIView *)target andCurrentIndex:(NSInteger)currentIndex{
    
    BOOL b = YES;
    
    for (id item in target.subviews) {
        
        ThridModel *model = [ThridModel mj_objectWithKeyValues:self.thridData.result.kind[currentIndex]];
        
        if ([item isKindOfClass:[UIImageView class]]) {
          
            
            [item sd_setImageWithURL:[NSURL URLWithString:model.pic]
                    placeholderImage:[UIImage imageNamed:@"placeholder"]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           }
             ];
        }
        
        if ([item isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)item;
            lab.textColor = [UIColor whiteColor];
            lab.font = [UIFont systemFontOfSize:25];
            
            if (b) {
                lab.text = model.cname;
                b = NO;
            }else{
                lab.text = model.ename;
            }
            
            
        }
        
    }
}


- (IBAction)oneBtn:(id)sender {
    
    [self clickLoadDataWithParameter:@"1"];
}


- (IBAction)twoBtn:(id)sender {
    [self clickLoadDataWithParameter:@"2"];
}

- (IBAction)threeBtn:(id)sender {
    [self clickLoadDataWithParameter:@"3"];
}

- (IBAction)fourBtn:(id)sender {
    [self clickLoadDataWithParameter:@"4"];
}

- (IBAction)fiveBtn:(id)sender {
    [self clickLoadDataWithParameter:@"5"];
}

- (IBAction)sixBtn:(id)sender {
    [self clickLoadDataWithParameter:@"6"];
}



-(void)clickLoadDataWithParameter:(NSString *)parameter{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DetailPage" bundle:nil];
    DetailPageViewController *vc = sb.instantiateInitialViewController;
    
    NSDictionary *parameters = @{@"type":parameter};
    [[NetWorkTools sharedNetworkTools]GET:@"API/Car/scene" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [DesData mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"result":@"DesModel",
                     };
        }];
        
        DesData *desData = [DesData mj_objectWithKeyValues:responseObject];
        vc.desModel = desData.result;
        
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
