//
//  ClockCell.m
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/10.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "ClockCell.h"


@implementation ClockCell

- (void)awakeFromNib {
    // Initialization code
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) setClock:(Clock *)clock
{
    _clock = clock;
    self.titleLabel.text = _clock.title;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
