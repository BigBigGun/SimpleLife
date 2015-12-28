//
//  CustomPickerView.h
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/10.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CustomPickerView : UIView

@property (weak, nonatomic) IBOutlet UIButton *DoneButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


@property (weak, nonatomic) IBOutlet UIDatePicker *picker;
@property (weak, nonatomic) IBOutlet UITextField *alertTextField;

@property (copy, nonatomic) void (^cancelBlock)(NSString *date);
@property (copy, nonatomic) void (^doneBlock)(NSString *Date);

+ (instancetype) sharePicker;
@end
