//
//  ViewController.m
//  香哈数据源
//
//  Created by 陆俊伟 on 15/12/1.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "BreakFastController.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "MyViewController.h"
#import "FoodModel.h"
#import "MyCollectionViewCell.h"
#import "MJRefresh.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kURL(i) [NSString stringWithFormat:@"http://www.xiangha.com/caipu/caidan/410-%ld",i]


@interface BreakFastController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic) NSInteger ID;
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray *foodModelArr;

@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic) NSInteger i;

@end

@implementation BreakFastController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((kScreenWidth-6) / 2, (kScreenWidth-6) / 2 /1.27);
    flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.minimumLineSpacing = 2;
    self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) collectionViewLayout:flowLayout];
    
    [self headerMJRefresh];
    
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    self.collectView.backgroundColor = [UIColor whiteColor];
    [self.collectView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyCollectionViewCell"];
    [self.view addSubview:self.collectView];

    
    [self footerMJRefresh];
    [self addSwipGes];

}



- (void) headerMJRefresh
{
    self.collectView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_async(currentQueue, ^{
            self.ID = 1;
            self.i = 0;
            [self.foodModelArr removeAllObjects];
            [self getDataFromNet];
        });
        [self.collectView.mj_header endRefreshing];
    }];
    [self.collectView.mj_header beginRefreshing];
}

- (void) footerMJRefresh
{
    self.collectView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.ID++;
        [self getDataFromNet];
        
        [self.collectView.mj_footer endRefreshing];
    }];;
    [self.collectView.mj_footer beginRefreshing];
}


#pragma mark--collectView的协议方法
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.foodModelArr.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
    if (self.foodModelArr.count >= indexPath.row) {
        FoodModel *food = self.foodModelArr[indexPath.row];
        [cell setCell:food];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyViewController *tableViewVC = [[MyViewController alloc] init];
    tableViewVC.model = (FoodModel *)self.foodModelArr[indexPath.row];
    [self.navigationController pushViewController:tableViewVC animated:YES];
}


#pragma mark--请求数据
- (void) getDataFromNet
{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:kURL((long)self.ID)]];
    TFHpple *xx = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *arr = [xx searchWithXPathQuery:@"//ul"];
    for (TFHppleElement *element in arr) {
        if ([[element objectForKey:@"class"] isEqualToString:@"clearfix"]) {
            NSArray *arr = [element searchWithXPathQuery:@"//a"];
            for (TFHppleElement *element in arr) {
                NSArray *arr = element.children;
                for (TFHppleElement *element in arr) {
                    if ([element.tagName isEqualToString:@"img"]) {
                        
                        FoodModel *food = [[FoodModel alloc] init];
                        food.imageStr = [element objectForKey:@"src"];
                        [self.arr addObject:food];

                    }
                }
            }
            NSArray *pArr = [element searchWithXPathQuery:@"//p"];
            for (TFHppleElement *element in pArr) {
                NSArray *arr = element.children;
                for (TFHppleElement *element in arr) {
                    
                    if ([element.tagName isEqualToString:@"a"]) {
                        
                            FoodModel *food = self.arr[self.i];
                            food.titile = [element objectForKey:@"title"];
                            food.detailStr = [element objectForKey:@"href"];
                            [self.foodModelArr addObject:food];
                            self.i++;
                    }
                }
            }
        }
    }

   dispatch_async(dispatch_get_main_queue(), ^{
       [self.collectView reloadData];
   });
    
}

- (NSMutableArray *)arr
{
    if (!_arr) {
        self.arr = [NSMutableArray array];
    }
    return _arr;
}

- (NSMutableArray *) foodModelArr
{
    if (!_foodModelArr) {
        self.foodModelArr = [NSMutableArray array];
    }
    return _foodModelArr;
}

#pragma mark--添加手势
- (void) addSwipGes
{
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipAction:)];
    [self.collectView addGestureRecognizer:swip];
}

-(void) swipAction:(UISwipeGestureRecognizer *)swip
{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.view.layer addAnimation:[self addCubeAnimationWithAnimationSubType:kCAMediaTimingFunctionEaseInEaseOut] forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0 / 255 green:130 / 255.0 blue:180 / 255.0 alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"早餐";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void) leftBarButtonItemAction:(UIBarButtonItem *)left
{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CATransition *)addCubeAnimationWithAnimationSubType:(NSString*)subType
{
    CATransition*animation=[CATransition animation];
    //设置动画效果
    [animation setType:@"suckEffect"];
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

@end
