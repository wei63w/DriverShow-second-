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
    
    [subAttrStr addAttribute:NSKernAttributeName value:@(20.0) range:NSMakeRange(0, str.length)];
    
    
    [self setAttributedText:subAttrStr];
}
@end
