//
//  DetailPageViewController.m
//  DriverShow
//
//  Created by 魏云超 on 16/8/27.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import "DetailPageViewController.h"
#import "MJExtension.h"


@interface DetailPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *nameTitle;

@property (weak, nonatomic) IBOutlet UILabel *min_title;
@property (weak, nonatomic) IBOutlet UILabel *mid_title;
@property (weak, nonatomic) IBOutlet UILabel *max_title;

@property (weak, nonatomic) IBOutlet UILabel *min_des;
@property (weak, nonatomic) IBOutlet UILabel *mid_des;
@property (weak, nonatomic) IBOutlet UILabel *max_des;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation DetailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    title.text = self.desModel.name;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    
    self.name.text = self.desModel.name;
    [self.name setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    self.nameTitle.text = self.desModel.title;
    [self.nameTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    
    self.min_title.text = self.desModel.min_title;
    [self.min_title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    
    self.mid_title.text = self.desModel.mid_title;
    [self.mid_title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    
    self.max_title.text = self.desModel.max_title;
    [self.max_title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    self.min_des.text = self.desModel.min_des;
    self.mid_des.text = self.desModel.min_des;
    self.max_des.text = self.desModel.max_des;
    self.max_des.numberOfLines = 0;
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
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"15110223870"];
//    UIWebView * callWebview = [[UIWebView alloc] init];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//    [self.view addSubview:callWebview];
    
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"18611983873"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
