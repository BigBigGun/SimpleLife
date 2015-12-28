//
//  CALayer+setBorderColorFromUIColor.m
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/8.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "CALayer+addition.h"

@implementation CALayer (addition)

//@synthesize borderUIColor = _borderUIColor;


-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

//-(UIColor*)borderUIColor
//{
//    return [UIColor colorWithCGColor:self.borderColor];
//}

@end
