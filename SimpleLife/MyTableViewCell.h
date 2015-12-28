//
//  MyTableViewCell.h
//  香哈数据源
//
//  Created by 陆俊伟 on 15/12/2.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YYKit.h"
#import "Step.h"

@interface MyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;

- (void) setCell:(Step *)step;

@end
