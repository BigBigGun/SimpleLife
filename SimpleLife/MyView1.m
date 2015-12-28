//
//  MyView.m
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/7.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "MyView1.h"

@implementation MyView1

+ (instancetype)initMyView
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MyView1" owner:nil options:nil];
    return [arr firstObject];
}

@end
