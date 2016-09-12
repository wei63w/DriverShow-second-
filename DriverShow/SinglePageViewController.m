//
//  SinglePageViewController.m
//  DriverShow
//
//  Created by 魏云超 on 16/8/28.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import "SinglePageViewController.h"
#import "HeadScrollView.h"

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width

@interface SinglePageViewController ()<HeadScrollViewDelegate,UIGestureRecognizerDelegate>

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) HeadScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UILabel *name;


@property (weak, nonatomic) IBOutlet UILabel *dayprice;


@property (weak, nonatomic) IBOutlet UILabel *weekprice;

@property (weak, nonatomic) IBOutlet UILabel *monthprice;
//车辆颜色
@property (weak, nonatomic) IBOutlet UILabel *colour;
//车牌号
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@end

@implementation SinglePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *title = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [title setTitle:self.lastModel.name forState:UIControlStateNormal];
    [title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     self.navigationItem.titleView = title;
    
    
    
    [self createInfiniteScrollView];
    
    self.name.text = self.lastModel.name;
    
    self.dayprice.text = [NSString stringWithFormat:@"%@/日",self.lastModel.dayprice];
    self.weekprice.text = [NSString stringWithFormat:@"%@/周",self.lastModel.weekprice];
    self.monthprice.text = [NSString stringWithFormat:@"按月/%@",self.lastModel.monthprice];
    self.colour.text = [NSString stringWithFormat:@"颜色/%@",self.lastModel.colour];
    self.number.text = [NSString stringWithFormat:@"车牌号/%@",self.lastModel.number];
    self.desc.text = self.lastModel.desc;
    
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


- (IBAction)btnTouch:(id)sender {
    
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"18611983873"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}


//创建顶部的轮播图
- (void)createInfiniteScrollView {
    
    NSArray *imgArr = [self.lastModel.pic componentsSeparatedByString:@"|"];
    
    //44
    self.scrollView = [[HeadScrollView alloc] init];
    
    self.scrollView.frame = CGRectMake(0,64, kDeviceWidth, 250 );
    self.scrollView.images = imgArr;//self.startModel.result.banner;
    self.scrollView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.scrollView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
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
