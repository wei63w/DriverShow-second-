//
//  DetailTableViewCell.m
//  DriverShow
//
//  Created by genilex3 on 16/8/26.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"


@interface DetailTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIView *rightView;

/**
 *  名称
 */
@property (weak, nonatomic) IBOutlet UILabel *carName;


/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *money;
/**
 *  方式
 */
@property (weak, nonatomic) IBOutlet UILabel *toWay;

@end
@implementation DetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
//    self.rightView.alpha = 0.7;
    [self.rightView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    self.money.textColor = [UIColor whiteColor];
    self.toWay.textColor =[UIColor whiteColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    [self setBackgroundColor:[UIColor clearColor]];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)DetailCellWithTbleView:(UITableView *)tableView{
    static NSString *ID = @"cell";
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil)
    {
        cell = [[DetailTableViewCell alloc]init];
    }
    return  cell;
}
-(void)setModel:(DetailCellModel *)model{
    
    
    [self.bgView sd_setImageWithURL:[NSURL URLWithString:model.imgStr]
                 placeholderImage:[UIImage imageNamed:@"defaultPic"]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        }
     ];
    
    self.carName.text = model.carName;
    self.money.text = [NSString stringWithFormat:@"￥%@/日(按周)",model.money];
    self.toWay.text = model.toWay;
}



@end
