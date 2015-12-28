//
//  ClockCell.h
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/10.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clock.h"

@interface ClockCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (nonatomic,strong) Clock *clock;

@end
