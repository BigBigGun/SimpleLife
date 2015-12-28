//
//  AlertView.m
//  SimpleLife
//
//  Created by 陆俊伟 on 15/11/30.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "AlertView.h"
#import "CALayer+addition.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kInDoor 0.0326
#define kOutDoor 0.0434


@interface AlertView ()

@property (nonatomic, strong) NSMutableDictionary *userDic;

@end



@implementation AlertView

+ (instancetype) shareAlertView
{
    static AlertView *alertView = nil;
    if (!alertView) {
        NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"AlertView" owner:nil options:nil];
        alertView = nibView[0];
    }
    return alertView;
}

//  点击体重按钮
- (IBAction)weightBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnDidTap:)]) {
        [self.delegate btnDidTap:sender];
    }
}

//  点击活动类型按钮
- (IBAction)activityBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnDidTap:)]) {
        [self.delegate btnDidTap:sender];
    }
}

//  点击取消按钮
- (IBAction)cancelBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnDidTap:)]) {
        [self.delegate btnDidTap:sender];
    }
}

//  点击确认按钮
- (IBAction)certainBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnDidTap:)]) {
        [self.delegate btnDidTap:sender];
    }
}

- (void) totalWater
{
    [self setStyleIdWithString];
    NSNumber *number = @([self.weightButton.currentTitle intValue] * self.styleId * 1000);
    self.drinkQuantity.text = [NSString stringWithFormat:@"%@",number];
}

- (void) setStyleIdWithString
{
    if ([self.activity.currentTitle isEqualToString:@"户外工作者"]) {
        self.styleId = kOutDoor;
    }
    else{
        self.styleId = kInDoor;
    }
}

- (void)writeInPlist
{
    NSString *xx = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *plistPath = [xx stringByAppendingPathComponent:@"Setting.plist"];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first"]) {

        [self.userDic setObject:[NSString stringWithFormat:@"%f",self.styleId] forKey:@"styleId"];
        [self.userDic setObject:self.drinkQuantity.text forKey:@"totalWater"];
        [self.userDic setObject:self.weightButton.currentTitle forKey:@"weight"];
        [self.userDic writeToFile:plistPath atomically:YES];
    }else{
         NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
      [dic1 setObject:[NSString stringWithFormat:@"%f",self.styleId] forKey:@"styleId"];
        if(!self.drinkQuantity.text)
        {
            [self.weightButton setTitle:@"60" forState:UIControlStateNormal];
            [self totalWater];
            
            
        }
         [dic1 setObject:self.weightButton.currentTitle forKey:@"weight"];
        [dic1 setObject:self.drinkQuantity.text forKey:@"totalWater"];
         [dic1 writeToFile:plistPath atomically:YES];
    }
}

- (void) loadFromPlist
{
    NSString *xx = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *plistPath = [xx stringByAppendingPathComponent:@"Setting.plist"];
    NSDictionary *userdic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    self.styleId = [userdic[@"styleId"] floatValue];
    if (self.styleId == 0.036) {
        [self.activity setTitle:@"室内工作者" forState:UIControlStateNormal];
    }else
    {
        [self.activity setTitle:@"户外工作者" forState:UIControlStateNormal];
    }
    [self.weightButton setTitle:userdic[@"weight"] forState:UIControlStateNormal];
    self.drinkQuantity.text = userdic[@"totalWater"];

}


- (NSMutableDictionary *)userDic
{
    if (!_userDic) {
        self.userDic = [NSMutableDictionary dictionary];
    }
    return _userDic;
}


@end
