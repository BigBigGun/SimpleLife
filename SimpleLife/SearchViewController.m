//
//  SearchViewController.m
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/4.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomCell.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface SearchViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *VCarr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *imageArr;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self imageArr];
    [self initCollectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellWithReuseIdentifier:@"CustomCell111"];

    
    [self initLeftBarButton];
    
    
}

- (NSArray *)imageArr
{
    if (!_imageArr) {
        self.imageArr = @[@"洗手间.jpg", @"bank2.jpg", @"早餐.jpg", @"停车.jpg", @"公交2.jpg", @"dianying1.jpg"];
    }
    return _imageArr;
}


#pragma mark--collectionView的协议方法
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.VCarr.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCell111" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.backgroundColor = [UIColor brownColor];
    return cell;
}

#pragma mark--推出控制器
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewVC = [[NSClassFromString(self.VCarr[indexPath.row]) alloc]init];
    [self presentViewController:viewVC animated:YES completion:nil];
}


- (void) initCollectionView
{
    self.navigationController.navigationBar.translucent = NO;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((kScreenWidth - 15) / 2, (kScreenHeight -64 - 15) / 3);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"search"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (NSArray *)VCarr
{
    if (!_VCarr) {
        self.VCarr = @[@"ToiletController", @"BankViewController", @"BreakfastStoreViewController", @"ParkViewController", @"BusViewController", @"CinemaViewController"];
    }
    return _VCarr;
}

- (void) initLeftBarButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 24, 44);
    [btn setTitle:@"<" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0 / 255 green:130 / 255.0 blue:180 / 255.0 alpha:1];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)btnAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.title = @"搜附近";
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
