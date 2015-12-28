//
//  CustomTextField.h
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/9.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextField : UIView

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (copy, nonatomic) void (^passBottleSize)();
@property (copy, nonatomic) void (^cancellBlock)();
+ (instancetype) shareCustomTextField;
@end
