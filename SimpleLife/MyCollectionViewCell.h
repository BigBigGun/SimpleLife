//
//  MyCollectionViewCell.h
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/3.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodModel.h"

@interface MyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew1;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void) setCell:(FoodModel *)food;
@end
