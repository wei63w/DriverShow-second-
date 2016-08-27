//
//  LeftDetailTableViewCell.m
//  DriverShow
//
//  Created by 魏云超 on 16/8/27.
//  Copyright © 2016年 魏云超. All rights reserved.
//

#import "LeftDetailTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface LeftDetailTableViewCell()


@property (weak, nonatomic) IBOutlet UIImageView *carPic;

@property (weak, nonatomic) IBOutlet UILabel *carName;

@property (weak, nonatomic) IBOutlet UILabel *carPrice;

@end

@implementation LeftDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
+(instancetype)DetailCellWithTbleView:(UITableView *)tableView{
    static NSString *ID = @"cell";
    LeftDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil)
    {
        cell = [[LeftDetailTableViewCell alloc]init];
    }
    return  cell;
}
-(void)setModel:(DetailCellModel *)model{
    
    
    [self.carPic sd_setImageWithURL:[NSURL URLWithString:model.imgStr]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                          }
     ];
    
    self.carName.text = model.carName;
    self.carPrice.text = [NSString stringWithFormat:@"￥%@/日(按周)",model.money];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
