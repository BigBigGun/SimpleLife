//
//  MyViewController.m
//  香哈数据源
//
//  Created by 陆俊伟 on 15/12/2.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "MyViewController.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "Step.h"
#import "Meterial.h"
#import "MyTableViewCell2.h"
#import "MyTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


#define kScreenWidth1 [UIScreen mainScreen].bounds.size.width
#define kScreenHeight1 [UIScreen mainScreen].bounds.size.height

@interface MyViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

//  过渡数组
@property (nonatomic, strong) NSMutableArray *arr;

@property (nonatomic, strong) NSMutableArray *stepArr;

//  过渡数组
@property (nonatomic, strong) NSMutableArray *arr1;

@property (nonatomic, strong) UIView *view1;

@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.view addSubview:self.view1];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth1, kScreenHeight1 - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -300, [UIScreen mainScreen].bounds.size.width, 300)];
    self.imageView.backgroundColor = [UIColor redColor];
//    self.tableView.tableHeaderView = self.imageView;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0);
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.imageView];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.imageStr] placeholderImage:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyTableViewCell2" bundle:nil] forCellReuseIdentifier:@"MyTableViewCell2"];
    [self addSwipGes];
    
    
    
    
    
    dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(currentQueue, ^{
        [self getDataFromNet];
    });
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"%@",scrollView);
    if (scrollView.contentOffset.y < -300) {
        float scale = ABS(scrollView.contentOffset.y / 300);
        float imageX = scale * [UIScreen mainScreen].bounds.size.width;
        float imageY = scale * 300;
        float originY = - 300 *scale;
        float originX = (scale * [UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width) / 2;
        self.imageView.frame = CGRectMake(-originX, originY, imageX, imageY);
    }
    else
    {
        
//        self.imageView.frame = CGRectMake(0, scrollView.contentOffset.y, 375, 300);
//        NSLog(@"%@",self.imageView);
    }
    
}

- (UIView *)view1
{
    if (!_view1) {
        self.view1 = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _view1;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


-  (NSMutableArray *)arr
{
    if (!_arr) {
        self.arr = [NSMutableArray array];
    }
    return _arr;
}


-(NSMutableArray *)arr1
{
    if (!_arr1) {
        self.arr1 = [NSMutableArray array];
    }
    return _arr1;
}

- (NSMutableArray *)stepArr
{
    if (!_stepArr) {
        self.stepArr = [NSMutableArray array];
    }
    return _stepArr;
}


- (void) getDataFromNet
{
#pragma mark--详情页面的数据
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.model.detailStr]];
    TFHpple *xxx = [[TFHpple alloc] initWithXMLData:data];
        NSArray *arr1 = [xxx searchWithXPathQuery:@"//td"];
        for (TFHppleElement *element in arr1) {
            
    #pragma mark--正常处理
            NSArray *arr = element.children;
            for (TFHppleElement *element in arr) {
                
                Meterial *meterial = [[Meterial alloc] init];
                
                if ([element.tagName isEqualToString:@"div"]) {
                    
                    //  材料名字赋值
                    meterial.name = [element.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

                    NSArray *arr2 =  element.children;
                    for (TFHppleElement *elelment1 in arr2) {
    
                        
                        if ([elelment1.tagName isEqualToString:@"span"]) {
                            //  分量赋值
                            meterial.weight = elelment1.text;
                            
                            [self.dataArr addObject:meterial];
                        }
                    }
                }
            }
    
#pragma mark--特殊处理
            NSArray *arrI = [element searchWithXPathQuery:@"//img"];
            for (TFHppleElement *element in arrI) {
                
                Meterial *meterial = [[Meterial alloc] init];
                    //  材料名字赋值
                NSString *str = [element objectForKey:@"alt"];
                NSInteger i = str.length - 3;
                
                meterial.name = [str substringToIndex:i];
                
                [self.arr addObject:meterial];
            }
    
            NSArray *arrA = [element searchWithXPathQuery:@"//a"];
            for (TFHppleElement *element in arrA) {
                NSArray *arrC = [element searchWithXPathQuery:@"//span"];
                for (TFHppleElement *ele in arrC) {
                    
                    Meterial *meterial = self.arr[0];
                    
                    //  分量赋值
                    meterial.weight = ele.text;
                    [self.dataArr addObject:meterial];
                    [self.arr removeAllObjects];
                }
            }
        }

    
#pragma mark--步骤
    NSArray *arr10 = [xxx searchWithXPathQuery:@"//ul"];
    for (TFHppleElement *ele in arr10) {
        if ([[ele objectForKey:@"id"] isEqualToString:@"CookbookMake"]) {
            
            NSArray *arr11 = [ele searchWithXPathQuery:@"//img"];
            for (TFHppleElement *ele1 in arr11) {
                
                Step *step = [[Step alloc] init];
                step.imageStr = [ele1 objectForKey:@"data-src"];
                [self.arr1 addObject:step];
            
            }
            
            NSArray *arr12 = [ele searchWithXPathQuery:@"//p"];
            for (int i = 0;i<arr12.count;i++) {
                TFHppleElement *ele12 = arr12[i];
                NSArray *arr13 = [ele12 searchWithXPathQuery:@"//span"];
                Step *step = self.arr1[i];
                for (TFHppleElement *ele13 in arr13) {

                    step.step = [ele13.text stringByAppendingString:ele12.text];
                    [self.stepArr addObject:step];

                }
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });


}


#pragma mark--tableView协议方法
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArr.count;
    }
    else{
        return self.stepArr.count;
    }
}



- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {

                return @"  食材用料";
            }
            else
            {

                return @"  菜谱做法";
            }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:17 weight:0.5];
    label.backgroundColor = [UIColor colorWithRed:70.0 / 255 green:130 / 255.0 blue:180 / 255.0 alpha:1];
    if (section == 0) {
        label.text = @"  食材用料";
        return label;
    }
    else
    {
        label.text = @"  菜谱做法";
        return label;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MyTableViewCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell2" forIndexPath:indexPath];
        cell2.meterialLabel.text = [self appendMeterial:indexPath.row];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell2;
    }
    else{
        MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell" forIndexPath:indexPath];
        [cell setCell:(Step *)self.stepArr[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        Step *step = self.stepArr[indexPath.row];
        
        return ([self heightForLabel:step.step] + 0.5) > 160 ? ([self heightForLabel:step.step] + 0.5) : 160;
    }
    else{
        return 37;
    }
}


#pragma mark--拼接食材
- (NSString *) appendMeterial:(NSInteger)row
{
    Meterial *meterial = self.dataArr[row];
    if (meterial.weight == nil) {
        return meterial.name;
    }
    [[meterial.name stringByAppendingString:@":"] stringByAppendingString:meterial.weight];
    return [[meterial.name stringByAppendingString:@":"] stringByAppendingString:meterial.weight];
}


#pragma mark--label自适应
- (CGFloat) heightForLabel:(NSString *)str
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(165, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return rect.size.height + 9;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = [self.model.titile stringByAppendingString:@"做法"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0 / 255 green:130 / 255.0 blue:180 / 255.0 alpha:1];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"Share_72px_1178600_easyicon.net"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void) leftBarButtonItemAction:(UIBarButtonItem *)leftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark--分享
- (void) rightAction
{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic SSDKSetupShareParamsByText:self.navigationItem.title images:nil url:[NSURL URLWithString:self.model.detailStr] title:self.navigationItem.title type:SSDKContentTypeAuto];
    
    [ShareSDK showShareActionSheet:self.view1 items:nil shareParams:dic onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        if (state == SSDKResponseStateSuccess) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新浪微博" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"分享成功" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
} 

#pragma mark--添加手势
- (void) addSwipGes
{
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipAction:)];
    [self.tableView addGestureRecognizer:swip];
}

-(void) swipAction:(UISwipeGestureRecognizer *)swip
{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController.view.layer addAnimation:[self addCubeAnimationWithAnimationSubType:kCATransitionFade] forKey:nil];
    [self.navigationController  popViewControllerAnimated:YES];
}

-(CATransition *)addCubeAnimationWithAnimationSubType:(NSString*)subType
{
    CATransition*animation=[CATransition animation];
    //设置动画效果
    [animation setType:@"rippleEffect"];
    //设置动画方向
    [animation setSubtype:subType];
    //设置动画播放时间
    [animation setDuration:1.0f];
    //设置动画作用范围
//    [animation setTimingFunction:[CAMediaTimingFunctionfunctionWithName:kCAMediaTimingFunctionEaseOut]];
    return animation;
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
