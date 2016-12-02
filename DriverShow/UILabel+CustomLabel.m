//
//  UILabel+CustomLabel.m
//  DriverShow
//
//  Created by genilex3 on 16/10/11.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import "UILabel+CustomLabel.h"

@implementation UILabel (CustomLabel)


-(void)setCustomerAttributeTest:(NSString *)str{
    
    NSMutableAttributedString *subAttrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [subAttrStr addAttribute:NSKernAttributeName value:@(5.0) range:NSMakeRange(0, str.length)];
    //方正正粗黑简体  FZZhengHeiS-B-GB FZSongHei-B07S
    self.font = [UIFont fontWithName:@"Hiragino Sans GB" size:self.font.pointSize];
    
    [self setAttributedText:subAttrStr];
}

-(void)setCustomerFontWithStr:(NSString *)str{
    
    self.text = str;
    self.font = [UIFont fontWithName:@"Hiragino Sans GB" size:self.font.pointSize];
}

-(void)setCustomerFontWithStr:(NSString *)str AndSize:(CGFloat)size{
    
    self.text = str;
    self.font = [UIFont fontWithName:@"Hiragino Sans GB" size:size];
}
@end
