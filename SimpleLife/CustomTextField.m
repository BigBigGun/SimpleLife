//
//  CustomTextField.m
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/9.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "CustomTextField.h"
#import "AlertView.h"

@implementation CustomTextField

+ (instancetype) shareCustomTextField
{
    static CustomTextField *customView = nil;
    if (!customView) {
        NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"CustomTextField" owner:nil options:nil];
        customView = [nibView firstObject];
    }
    return customView;
}

- (IBAction)cancel:(id)sender {
    self.cancellBlock();
    [self removeFromSuperview];
}

- (IBAction)sureButtonAction:(id)sender {
    self.passBottleSize();
    [self removeFromSuperview];
}


@end
