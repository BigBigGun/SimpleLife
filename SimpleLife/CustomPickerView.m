//
//  CustomPickerView.m
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/10.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "CustomPickerView.h"

@interface CustomPickerView ()

@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSDate *alertDate;


@end

@implementation CustomPickerView

- (NSString *)dateStr
{
    if (!_dateStr) {
        NSDate *date = [NSDate date];
        NSDateComponents *components = [self getCustomDateComponentsWithDate:date];
        NSString *hour = [NSString stringWithFormat:@"%0.2ld",components.hour];
        NSString *minute = [NSString stringWithFormat:@":%0.2ld",components.minute];
        self.dateStr = [hour stringByAppendingString:minute];
    }
    return _dateStr;
}

-(void)awakeFromNib
{
    self.picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [self.picker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)dateChange:(id)sender
{
    UIDatePicker *currentDate = (UIDatePicker *)sender;
    NSDateComponents *components = [self getCustomDateComponentsWithDate:currentDate.date];
    NSString *hour = [NSString stringWithFormat:@"%0.2ld",components.hour];
    NSString *minute = [NSString stringWithFormat:@":%0.2ld",components.minute];
    self.dateStr = [hour stringByAppendingString:minute];
//    NSLog(@"+++++++%@",currentDate.date);
    self.alertDate = currentDate.date;
}

- (NSDateComponents *) getCustomDateComponentsWithDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *com = [calendar components:unitFlags fromDate:date];
//    NSLog(@"%@",com);
    return com;
}



+ (instancetype) sharePicker
{
    CustomPickerView *picker;
    picker = [[[NSBundle mainBundle] loadNibNamed:@"CustomPickerView" owner:nil options:nil] firstObject];
    return picker;
}


- (IBAction)doneButtonAction:(id)sender {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:self.alertDate forKey:@"alertDate"];
    [user setObject:self.alertTextField.text forKey:@"alertTitle"];
    
    self.doneBlock(self.dateStr);
    
}
- (IBAction)cancelButtonAction:(id)sender {
    self.cancelBlock(self.dateStr);
}

@end
