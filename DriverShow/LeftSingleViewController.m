//
//  LeftSingleViewController.m
//  DriverShow
//
//  Created by genilex3 on 16/9/12.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import "LeftSingleViewController.h"
#import "HeadScrollView.h"
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width

@interface LeftSingleViewController ()<HeadScrollViewDelegate,UIGestureRecognizerDelegate>

//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) HeadScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

/**
 *  车名
 */
@property (weak, nonatomic) IBOutlet UILabel *carName;
/**
 *  车价格
 */
@property (weak, nonatomic) IBOutlet UILabel *carPrice;

@end

@implementation LeftSingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *title = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [title setTitle:@"婚车详情" forState:UIControlStateNormal];
    [title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.titleView = title;
    self.carName.text = self.leftSingle.name;
    self.carPrice.text = [NSString stringWithFormat:@"￥%@元",self.leftSingle.price];
    [self setLeftBarButtonItem];
    [self createInfiniteScrollView];
}

//呼叫转移
- (IBAction)btnTouch:(id)sender {
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"18611983873"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
//创建顶部的轮播图
- (void)createInfiniteScrollView {
    
    NSArray *imgArr = [_leftSingle.pic componentsSeparatedByString:@"|"];

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
