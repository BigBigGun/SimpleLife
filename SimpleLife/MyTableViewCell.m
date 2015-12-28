//
//  MyTableViewCell.m
//  香哈数据源
//
//  Created by 陆俊伟 on 15/12/2.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "MyTableViewCell.h"
#import "UIImageView+WebCache.h"

#define kScreenWidth1 [UIScreen mainScreen].bounds.size.width

@implementation MyTableViewCell

- (void)awakeFromNib {
  
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setCell:(Step *)step
{
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:step.imageStr] placeholderImage:[UIImage imageNamed:@"xxxx.jpeg"]];

    self.stepLabel.text = step.step;
    self.stepLabel.layer.shouldRasterize = YES;
    self.stepLabel.numberOfLines = 0;
    self.stepLabel.layer.cornerRadius = 5;
//    self.stepLabel.layer.masksToBounds = YES;
    self.stepLabel.clipsToBounds = YES;

}




@end
