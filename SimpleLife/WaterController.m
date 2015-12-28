//
//  WaterViewController.m
//  SimpleLife
//
//  Created by 陆俊伟 on 15/11/30.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "WaterController.h"
#import "AlertView.h"
#import "UIImageView+WebCache.h"
#import "XYPieChart.h"
#import "CustomTextField.h"
#import <MapKit/MapKit.h>
#import "ClockViewController.h"


#define kInDoor 0.326
#define kOutDoor 0.434

@interface WaterController () <UITableViewDataSource,UITableViewDelegate,AlertViewDelegate,XYPieChartDelegate,XYPieChartDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *weightArr;
@property (nonatomic, strong) NSMutableArray *Style;
@property (nonatomic, strong) UIButton *setButton;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *effectView;

@property (weak, nonatomic) IBOutlet XYPieChart *chart;
@property (nonatomic, strong) NSArray *colorArr;
@property (nonatomic, strong) NSMutableArray *drinkArr;

@property (weak, nonatomic) IBOutlet UILabel *bottleSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;

@property (weak, nonatomic) IBOutlet UIButton *userBottleLabel;

@end

@implementation WaterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
//    imageView.image = [UIImage imageNamed:@"water.jpg"];
//    [self.view addSubview:imageView];
    
    
//    [self initAlertView];
    [self initSetButtion];
    
//    CGFloat height = kScreenHeight;
//    CGFloat width = kScreenWidth;
   [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastTime"];
    
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"first"];
        [self loadEffectView];
        [self initAlertView];
        self.bottleSizeLabel.text = @"0ml";
        //  饼图
        [self initChartData];
        self.chart.showLabel = YES;
        self.chart.delegate = self;
        self.chart.dataSource = self;
    }else{
        
        self.bottleSizeLabel.text = [self readFromPlist:@"bottleSize"];
        self.targetLabel.text = [self mlConvertL:@"totalWater"];
        //  饼图
        [self initChartData];
        self.chart.showLabel = YES;
        self.chart.delegate = self;
        self.chart.dataSource = self;
    }
    
    if (![self isSameDay]) {
        [self.drinkArr removeAllObjects];
        [self.drinkArr addObject:@(0)];
        [self.drinkArr addObject:@(100)];
        
        [self writeIntoPlist:self.drinkArr andKey:@"drinkArr"];
    }
    
    
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
  

    self.chart.showPercentage = YES;
    if([UIScreen mainScreen].bounds.size.height == 568)
    {
        self.chart.frame = CGRectMake(self.chart.frame.origin.x+10, self.chart.frame.origin.y+60, self.chart.frame.size.width - 20, self.chart.frame.size.height-20);
        self.chart.pieCenter = CGPointMake(self.chart.width / 2 , self.chart.height / 2 );
    }else if ([UIScreen mainScreen].bounds.size.height == 667){
        self.chart.frame = CGRectMake(self.chart.origin.x-10, self.chart.frame.origin.y+10, kScreenWidth - 60, kScreenWidth - 60);
        self.chart.pieRadius = self.chart.width / 2 - 20;
        self.chart.pieCenter = CGPointMake(self.chart.width / 2 , self.chart.height / 2 );
    }else if ([UIScreen mainScreen].bounds.size.height == 736){
    
        self.chart.frame = CGRectMake(self.chart.origin.x-10, self.chart.frame.origin.y, kScreenWidth - 60, kScreenWidth - 60);
        self.chart.pieRadius = self.chart.width / 2 ;
        self.chart.pieCenter = CGPointMake(self.chart.width / 2 , self.chart.height / 2 );
    }else{
        self.chart.frame = CGRectMake(self.chart.origin.x-30, self.chart.frame.origin.y+70, 80, 80);
        self.chart.pieRadius = 80;
        self.bottleSizeLabel.frame = CGRectMake(self.bottleSizeLabel.frame.origin.x, self.bottleSizeLabel.frame.origin.y + 30, self.bottleSizeLabel.frame.size.width, self.bottleSizeLabel.frame.size.height);
        self.userBottleLabel.frame = CGRectMake(self.userBottleLabel.frame.origin.x, self.userBottleLabel.frame.origin.y + 30, self.userBottleLabel.frame.size.width, self.userBottleLabel.frame.size.height);
    }

}

#pragma mark--饼状图
- (NSArray *)colorArr
{
    if (!_colorArr) {
//        self.colorArr = [NSMutableArray array];
        self.colorArr = [NSMutableArray arrayWithObjects:[UIColor colorWithRed:31/255.0 green:217/255.0 blue:10/255.0 alpha:1], [UIColor colorWithRed:240/255.0 green:101/255.0 blue:22/255.0 alpha:1], nil];
    }
    return _colorArr;
}

- (NSMutableArray *)drinkArr
{
    if (!_drinkArr) {
        self.drinkArr = [NSMutableArray array];
    }
    return _drinkArr;
}

- (void) initChartData
{
//    AlertView *alertView = [AlertView shareAlertView];
    
//    self.colorArr = @[[UIColor purpleColor], [UIColor whiteColor]];
    if( ![self readFromPlist:@"drinkArr"]){
        [self.drinkArr addObject:@(0)];
        [self.drinkArr addObject:@(100)];
        
    }else {
        self.drinkArr = [self readFromPlist:@"drinkArr"];
    }
  
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    
    return self.drinkArr.count;
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    
    return [self.drinkArr[index] floatValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return self.colorArr[index];
}

- (IBAction)didDrink:(id)sender {
    [self drinkArrReset];
    
}

- (IBAction)cancelDrink:(id)sender {
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Setting.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray *arr = dic1[@"drinkArr"];

    float didDrink = [[arr firstObject] floatValue];
    if ((int)didDrink <= 0) {
        arr = @[@(0), @(100)];
        [self writeIntoPlist:arr andKey:@"drinkArr"];
    }else{
        float b = [self.targetLabel.text floatValue] * 1000;
        float a = [self.bottleSizeLabel.text floatValue];
        float factor = a / b;
        float drinkOnce = factor * 100;
        didDrink = didDrink - drinkOnce;
        if ((int)didDrink < 0) {
            arr = @[@(0), @(100)];
            [self writeIntoPlist:arr andKey:@"drinkArr"];
        }else{
        arr = @[@(didDrink), @(100 - didDrink)];
        [self writeIntoPlist:arr andKey:@"drinkArr"];
        }
    }
            self.drinkArr = [NSMutableArray arrayWithArray:arr];
    [self.chart reloadData];

}

- (IBAction)userSetBottle:(id)sender {
    CustomTextField *customView = [CustomTextField shareCustomTextField];
    [self loadEffectView];
    customView.frame = CGRectMake(0, 0, 291, 100);
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        customView.center = CGPointMake(kScreenWidth /2, kScreenHeight / 2-30);
    }else{
    
    customView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    }
    [self.view addSubview:customView];
    
    __block CustomTextField *weakView = customView;
    customView.passBottleSize = ^()
    {
        [self.effectView removeFromSuperview];
        self.bottleSizeLabel.text = [weakView.textField.text stringByAppendingString:@"ml"];
        [self writeIntoPlist:self.bottleSizeLabel.text andKey:@"bottleSize"];
    };
    
    customView.cancellBlock = ^()
    {
        [self.effectView removeFromSuperview];
    };
}


- (void) initSetButtion
{
    self.setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.setButton.frame = CGRectMake(25, kScreenHeight / 7, 30, 30);
//    self.setButton.backgroundColor = [UIColor cyanColor];
    [self.setButton setTitle:@"设置" forState:UIControlStateNormal];
    [self.setButton setImage:[UIImage imageNamed:@"config_set_72px_548300_easyicon.net"] forState:UIControlStateNormal];
    [self.setButton addTarget:self action:@selector(setButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.setButton];
    
}

#pragma mark--alertView的协议方法
- (void)btnDidTap:(UIButton *)btn
{
    AlertView *alertView = [AlertView shareAlertView];
    
    if (btn == alertView.cancel) {
        if (alertView.weightButton.currentTitle.length == 0) {
            [alertView writeInPlist];
            self.targetLabel.text = [[NSString stringWithFormat:@"%0.2f",[alertView.drinkQuantity.text floatValue] / 1000] stringByAppendingString:@" L"];
           self.chart.showPercentage = YES;
            [self.chart reloadData];
        }
        [self.effectView removeFromSuperview];
        [alertView removeFromSuperview];
   
    }else if (btn == alertView.certain){
        
        [self.drinkArr removeAllObjects];
        [self.drinkArr addObject:@(0)];
        [self.drinkArr addObject:@(100)];
        [self writeIntoPlist:self.drinkArr andKey:@"drinkArr"];
        [self.effectView removeFromSuperview];
        [alertView writeInPlist];
        self.chart.showPercentage = YES;
        [self.chart reloadData];
        self.targetLabel.text = [[NSString stringWithFormat:@"%0.2f",[alertView.drinkQuantity.text floatValue] / 1000] stringByAppendingString:@" L"];
        [alertView removeFromSuperview];

    
    }else if(btn == alertView.weightButton){
        
//        [self loadEffectView];
        self.dataArr = self.weightArr;
//        [self tableView];
        self.chart.showPercentage = YES;
        [self.tableView reloadData];
    
    }else{

//        [self loadEffectView];
        self.dataArr = self.Style;
//        [self tableView];
        self.chart.showPercentage = YES;
       [self.tableView reloadData];
    }
//    [self.effectView removeFromSuperview];
}

#pragma mark--模糊view
- (void) loadEffectView
{
    self.effectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.effectView.backgroundColor = [UIColor grayColor];
    self.effectView.alpha = 0.7;
    self.effectView.userInteractionEnabled = YES;
    [self.view addSubview:self.effectView];
}


#pragma mark--设置按钮的点击
- (void) setButtonAction:(UIButton *)btn
{
    [self loadEffectView];
    [self initAlertView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        
        [self weightArr];
        [self Style];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 75, kScreenWidth - 75, kScreenHeight - 67-75) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.center = CGPointMake(kScreenWidth / 2, (kScreenHeight + 75) / 2);
    }
    
    [self.view addSubview:_tableView];
    return _tableView;
}

- (void) initAlertView
{
    AlertView *alertView = [AlertView shareAlertView];
    alertView.delegate = self;
    self.targetLabel.text = [[NSString stringWithFormat:@"%0.2f",[alertView.drinkQuantity.text floatValue] / 1000] stringByAppendingString:@" L"];
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        alertView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2 + 30);
    }
    else{
        alertView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    }
    [self.view addSubview:alertView];
}

#pragma mark--tableView的协议方法
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xxx"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xxx"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row]];
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlertView *alertView = [AlertView shareAlertView];
    if (self.dataArr == self.weightArr) {
        [alertView.weightButton setTitle:[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row]] forState:UIControlStateNormal];
    }else{
        [alertView.activity setTitle:[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row]] forState:UIControlStateNormal];
    }
    [alertView totalWater];
//    [self.effectView removeFromSuperview];
    [self.tableView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0 / 255 green:130 / 255.0 blue:180 / 255.0 alpha:1];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 24, 44);
    [button setTitle:@"<" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 30, 30);
    [right setImage:[UIImage imageNamed:@"alert_horn_128px_1132457_easyicon.net"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    
    self.title = @"饮水小助手";
    
    
    [self.chart reloadData];
}

#pragma mark--设置提醒
- (void)rightBarButtonItemAction:(UIButton *)btn
{
    ClockViewController *clock = [[ClockViewController alloc] init];
    [self.navigationController pushViewController:clock animated:YES];
}

- (void) buttonAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark--懒加载
- (NSMutableArray *)weightArr
{
    if (!_weightArr) {
        self.weightArr = [NSMutableArray array];
        for (int i = 20; i < 251; i++) {
            [self.weightArr addObject:@(i)];
        }
    }
    return _weightArr;
}

- (NSMutableArray *) Style
{
    if (!_Style) {
        self.Style = [NSMutableArray array];
        [self.Style addObject:@"户外工作者"];
        [self.Style addObject:@"室内工作者"];
    }
    return _Style;
}



- (void)writeIntoPlist:(id)value andKey:(NSString *)key
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Setting.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dic1 setObject:value forKey:key];
    [dic1 writeToFile:plistPath atomically:YES];
    NSLog(@"---%@",plistPath);
}

- (id) readFromPlist:(NSString *)key
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Setting.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    return dic[key];
}

- (void) drinkArrReset
{
//    static float didDrink;
    float didDrink = [[[self readFromPlist:@"drinkArr"] firstObject] floatValue];
//    float a = [self.bottleSizeLabel.text floatValue];
    float b = [self.targetLabel.text floatValue] * 1000;
    float a = [self.bottleSizeLabel.text floatValue];
    float factor = a / b;
    float drinkOnce = factor * 100;
    didDrink = didDrink + drinkOnce;
    float left = 100 - didDrink;
    if (left <= 0) {
#pragma mark--已经喝了足够多的水
        
        self.drinkArr  = [NSMutableArray arrayWithObjects:@(100),@(0), nil];

    }else{
    [self.drinkArr removeAllObjects];
    [self.drinkArr addObject:@(didDrink)];
    [self.drinkArr addObject:@(left)];

    }
    [self writeIntoPlist:self.drinkArr andKey:@"drinkArr"];
    [self.chart reloadData];
}


- (void) deletePlist:(NSString *)key
{
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Setting.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dic1 removeObjectForKey:key];
}

- (NSString *) mlConvertL:(NSString *)key
{
    NSString *str = [self readFromPlist:key];
    float aa = [str floatValue];
    return [[NSString stringWithFormat:@"%0.2f", aa / 1000] stringByAppendingString:@"L"];
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

- (BOOL) isSameDay
{
    NSDate *date = [NSDate date];
    NSDate *lastTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastTime"];
    NSDateComponents *current = [self getCustomDateComponentsWithDate:date];
    NSDateComponents *last = [self getCustomDateComponentsWithDate:lastTime];
    if (current.day == last.day) {
        return YES;
    }else{
        return NO;
    }
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
