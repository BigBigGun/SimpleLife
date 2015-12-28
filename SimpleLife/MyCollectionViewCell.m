//
//  MyCollectionViewCell.m
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/3.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "MyCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation MyCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setCell:(FoodModel *)food
{
    self.titleLabel.text = food.titile;
    self.titleLabel.backgroundColor = [UIColor colorWithRed:70.0 / 255 green:130 / 255.0 blue:180 / 255.0 alpha:1];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.imageVIew1 sd_setImageWithURL:[NSURL URLWithString:food.imageStr] placeholderImage:[UIImage imageNamed:@"xxxx.jpeg"]];
}

@end
