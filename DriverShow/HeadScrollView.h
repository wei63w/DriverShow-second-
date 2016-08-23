//
//  HeadScrollView.h
//  DriverShow
//
//  Created by genilex3 on 16/8/22.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import <UIKit/UIKit.h>

//给图片添加点击事件时调用改代理方法
@protocol HeadScrollViewDelegate <NSObject>

@optional
- (void)ScrollViewDidClickAtAnyImageView:(UIImageView *)imageView;

@end

@interface HeadScrollView : UIView

@property (strong, nonatomic) NSArray *images;
@property (weak, nonatomic, readonly) UIPageControl *pageControl;
@property (assign, nonatomic, getter=isScrollDirectionPortrait) BOOL scrollDirectionPortrait;

//代理
@property (nonatomic, weak) id<HeadScrollViewDelegate> delegate;

@end
