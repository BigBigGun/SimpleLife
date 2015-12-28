//
//  ViewController.m
//  SimpleLife
//
//  Created by 陆俊伟 on 15/11/30.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "MainViewController.h"
#import "RFLayout.h"
#import "CollectionViewCell.h"
//#import "WaterController.h"
//#import "SearchViewController.h"
//#import "BreakFastController.h"
#import "AlertView.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *controllerArr;

@property (nonatomic, strong) NSMutableArray *nameArr;

@property (nonatomic, strong) NSMutableArray *imageArr;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    
    [self controllerArr];
    [self initCollectView];
}

#pragma mark--出事话collectView
- (void) initCollectView
{
    RFLayout *layout = [[RFLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //  2.初始化背景视图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//
//    //  3.对背景视图进行赋值
    imageView.image = [UIImage imageNamed:@"c.jpeg"];
    
    //  4.将背景视图添加到tabkeView上
    self.collectionView.backgroundView = imageView;
    
//    //  5.创建模糊效果视图
//    UIVisualEffectView *visuaEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    
////      6.设置模糊效果的大小
//    visuaEffectView.frame = [UIScreen mainScreen].bounds;
    
    //  7.让这个模糊效果对谁起作用
//    [imageView addSubview:visuaEffectView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    

}

- (NSMutableArray *)imageArr
{
    if (!_imageArr) {
        self.imageArr = [NSMutableArray arrayWithObjects:@"10.jpg",@"20.jpg",@"30.png",@"40.jpg", nil];
    }
    return _imageArr;
}


#pragma mark--控制器数组和名称数组懒加载
- (NSMutableArray *)controllerArr
{
    if (!_controllerArr) {
        NSArray *arr = @[@"WaterController", @"SearchViewController", @"BreakFastController", @"MyController"];
        self.controllerArr = [NSMutableArray arrayWithArray:arr];
        self.nameArr = [NSMutableArray arrayWithObjects:@"饮水提醒", @"一键搜", @"早餐制作",@"免责声明", nil];
    }
    return _controllerArr;
}

#pragma mark--collectView协议方法
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.controllerArr.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.nameArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *subVC = [[NSClassFromString(self.controllerArr[indexPath.row]) alloc] init];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    

        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:subVC];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:navi animated:YES completion:nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
