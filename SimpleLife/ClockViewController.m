//
//  ClockViewController.m
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/10.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "ClockViewController.h"
#import "ClockCell.h"
#import "Clock.h"
#import "CustomPickerView.h"
#import <AVFoundation/AVFoundation.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height



@interface ClockViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) NSMutableArray *indexPathArr;
@property (nonatomic, strong) UIView *effectView;
@property (nonatomic) NSTimeInterval fireTime;
@property (nonatomic, strong) CustomPickerView *picker;


@property (nonatomic, strong) ClockCell *currentCell;

@end

@implementation ClockViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    
    [self initData];
    [self initTableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ClockCell" bundle:nil] forCellReuseIdentifier:@"clockCell"];
}

- (void) initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    label.text = @"    通知";
//    label.backgroundColor = [UIColor cyanColor];
    label.textColor = [UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255 alpha:1];
    return label;
}


- (NSMutableArray *)arr
{
    if (!_arr) {
        self.arr = [NSMutableArray array];
    }
    return _arr;
}

- (NSMutableArray *)indexPathArr
{
    if (!_indexPathArr) {
        self.indexPathArr = [NSMutableArray array];
    }
    return _indexPathArr;
}

- (void) initData
{
    NSArray *arr1 = @[@"通知",@"现在时间",@"提醒时间"];
    for (int i = 0; i< arr1.count;i++) {
        
        Clock *clock = [[Clock alloc] init];
        clock.title = arr1[i];
        clock.response = YES;
        [self.arr addObject:clock];
        
    }
}




- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clockCell" forIndexPath:indexPath];
//    NSLog(@"%@",cell);
    if (indexPath.row == 1) {
        
        [cell.imageView1 removeFromSuperview];
        cell.subTitleLabel.text = [self nowDate];
        
    }else if (indexPath.row == 2){
        [cell.imageView1 removeFromSuperview];
        if (![self isExsitUserTimeInDefault:@"fireTime"]) {
            cell.subTitleLabel.text = @"设置提醒时间";
        }else{
            cell.subTitleLabel.text = [self getValueFromDefault:@"fireTime"];
        }
    }

    
        cell.clock = self.arr[indexPath.row];
        cell.selectionStyle = cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:52.0 / 255 green:100 / 255.0 blue:255 / 255.0 alpha:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClockCell *cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ClockCell *cell3 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    ClockCell *cell4 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if (indexPath.row == 0) {
        
        cell1.imageView1.hidden = !cell1.imageView1.hidden;
        cell3.clock.response = !cell3.clock.response;
        cell4.clock.response = !cell4.clock.response;
        
        if (cell1.imageView1.hidden) {
            cell3.contentView.backgroundColor = [UIColor grayColor];
            cell4.contentView.backgroundColor = [UIColor grayColor];
        }else{

            cell3.contentView.backgroundColor = [UIColor colorWithRed:52.0 / 255 green:100 / 255.0 blue:255 / 255.0 alpha:1];
            cell4.contentView.backgroundColor = [UIColor colorWithRed:52.0 / 255 green:100 / 255.0 blue:255 / 255.0 alpha:1];
        }
    }
    
    if (cell3.clock.response == YES){
        

        if ([tableView cellForRowAtIndexPath:indexPath] == cell3){
            
            self.currentCell = [tableView cellForRowAtIndexPath:indexPath];
    
        }else if ([tableView cellForRowAtIndexPath:indexPath] == cell4){
            self.currentCell = [tableView cellForRowAtIndexPath:indexPath];
            [self loadPickerView];
        }
        if (indexPath.row != 2) {
            [self createNotification];
        }
        
    }else{
        NSLog(@"取消了通知!!");
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (void) viewWillAppear:(BOOL)animated
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 24, 44);
    [button setTitle:@"<" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)buttonAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) loadEffectView
{
    self.effectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.effectView.backgroundColor = [UIColor grayColor];
    self.effectView.alpha = 0.7;
    self.effectView.userInteractionEnabled = YES;
    [self.view addSubview:self.effectView];
}


- (void) loadPickerView
{
    [self loadEffectView];
    self.picker = [CustomPickerView sharePicker];
    NSLog(@"%@",self.picker);
    self.picker.alertTextField.delegate = self;
    if([UIScreen mainScreen].bounds.size.height == 480)
    {
        self.picker.size = CGSizeMake(300, 260);
        self.picker.center = CGPointMake(self.view.center.x, self.view.center.y-20);
        
    }else{
        
        self.picker.center = CGPointMake(self.view.center.x, self.view.center.y-20);
        
    }
    [self.view addSubview:self.picker];
    __block CustomPickerView *weakPicker = self.picker;
    __block ClockViewController *weakSelf = self;
    
    self.picker.cancelBlock = ^(NSString *date)
    {
        [weakSelf setCellTime:date];
        [weakSelf.effectView removeFromSuperview];
        [weakPicker removeFromSuperview];
    };
    
    self.picker.doneBlock = ^(NSString *date)
    {
        [weakSelf setCellTime:date];
        [weakSelf alertDateMinusNowDate];
        
        [weakSelf createNotification];
        [weakSelf.effectView removeFromSuperview];
        [weakPicker removeFromSuperview];
    };
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.picker.transform = CGAffineTransformTranslate(self.picker.transform, 0, -130);
    } completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.picker.transform = CGAffineTransformIdentity;
    } completion:nil];
    [self.picker.alertTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.picker.transform = CGAffineTransformIdentity;
    } completion:nil];
    [self.view endEditing:YES];
}


- (id) getValueFromDefault:(NSString *)key
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    id value = [user objectForKey:key];
    return value;
}

- (void) saveToDefault:(NSString *)key andValue:(id)value
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:value forKey:key];
}


- (BOOL) isExsitUserTimeInDefault:(NSString *)key
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:key]) {
        return YES;
    }else{
        return NO;
    }
}





- (void) setCellTime:(NSString *)date
{
    if (self.currentCell == [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]) {
       
        
 
        [self saveToDefault:@"nowTime" andValue:date];
    }else{
        self.currentCell.subTitleLabel.text = date;
        [self saveToDefault:@"fireTime" andValue:date];
    }
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

- (NSString *) nowDate
{
    NSDateComponents *components = [self getCustomDateComponentsWithDate:[NSDate date]];
    NSString *hour = [NSString stringWithFormat:@"%0.2ld",(long)components.hour];
    NSString *minute = [NSString stringWithFormat:@":%0.2ld",(long)components.minute];
    return [hour stringByAppendingString:minute];
}





- (void) createNotification
{
    if ([self alertDateCompareNowDate]) {
        if ([[UIApplication sharedApplication]currentUserNotificationSettings].types!=UIUserNotificationTypeNone) {
            
            if (self.fireTime != 0) {
                
                [[UIApplication sharedApplication] cancelAllLocalNotifications];
                [self initNotification];
            }
        }
    }
}




- (void) initNotification
{
    UILocalNotification *localNoti = [[UILocalNotification alloc] init];
    localNoti.fireDate = [self getValueFromDefault:@"alertDate"];
    
    if (![[self getValueFromDefault:@"alertTitle"]  isEqual:@""]) {
        NSLog(@"%@",[self getValueFromDefault:@"alertTitle"]);
        localNoti.alertBody = [self getValueFromDefault:@"alertTitle"];
    }else{
        localNoti.alertBody = @"便捷生活助手提醒你";
    }
    localNoti.alertTitle = @"便捷生活助手";
    localNoti.repeatInterval = 2;
    localNoti.alertAction = @"打开应用"; //待机界面的滑动动作提示
    localNoti.alertLaunchImage = @"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
    localNoti.soundName = @"msg.caf";
//    localNoti.soundName = @"alarm.caf";
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    if (self.fireTime > 0) {
        NSLog(@"通知创建成功!");
        [[UIApplication sharedApplication]scheduleLocalNotification:localNoti];
    }
}


- (BOOL) alertDateCompareNowDate
{
    NSDate *alertDate = [self getValueFromDefault:@"alertDate"];
    NSDate *nowDate = [NSDate date];
    NSDateComponents *alertCom = [self getCustomDateComponentsWithDate:alertDate];
    NSDateComponents *nowCom = [self getCustomDateComponentsWithDate:nowDate];
    NSInteger hour = alertCom.hour - nowCom.hour;
    NSInteger minute = alertCom.minute - nowCom.minute;
    if (hour >= 0) {
        if (minute >= 0) {
            return YES;
        }
        return NO;
    }else{
        return NO;
    }
}

- (void) alertDateMinusNowDate
{
    NSDate *alertDate = [self getValueFromDefault:@"alertDate"];
    NSDate *nowDate = [NSDate date];
    NSDateComponents *alertCom = [self getCustomDateComponentsWithDate:alertDate];
    NSDateComponents *nowCom = [self getCustomDateComponentsWithDate:nowDate];
    NSInteger hour = alertCom.hour - nowCom.hour;
    NSInteger minute = alertCom.minute - nowCom.minute;

    self.fireTime = minute * 60 + hour * 60 * 60;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
