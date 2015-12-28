//
//  BaseViewController.m
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/4.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

//气泡视图的的点击方法
//位置连线
//定位城市


#import "BaseViewController.h"
#import "CalloutView.h"
#import "CustomAnnotationView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface BaseViewController () <CalloutViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *nameArr;
@property (nonatomic, strong) NSMutableArray *annotationArr;

@property (nonatomic, strong) UIButton *traffic;
@property (nonatomic, strong) UIButton *map;



@end


@implementation BaseViewController

@synthesize annotationArr = _annotationArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initMapView];
    [self initSearch];
    
    [self tableView];
    [self initSearchBar];
    [self initMyLabel];
    [self initTrafficMap];
    
}

- (void) initMyLabel
{
    self.label = [MyView1 initMyView];
    self.label.addressLabel.numberOfLines = 0;
    self.label.frame = CGRectMake(0, kScreenHeight + 40, kScreenWidth, 40);
    self.label.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    [self.view addSubview:self.label];
}

- (void)returnAction
{
    [self clearSearch];
    [self clearmapView];
    
    [self.view.layer addAnimation:[self addCubeAnimationWithAnimationSubType:kCATransitionFromLeft] forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.mapView removeFromSuperview];
}

-(CATransition *)addCubeAnimationWithAnimationSubType:(NSString*)subType
{
    CATransition*animation=[CATransition animation];
    //设置动画效果
    [animation setType:@"rippleEffect"];
    //设置动画方向
    //    [animation setSubtype:kCATransitionFromLeft];
    //设置动画播放时间
    [animation setDuration:1.0f];
    //设置动画作用范围
    //    [animation setTimingFunction:[CAMediaTimingFunctionfunctionWithName:kCAMediaTimingFunctionEaseOut]];
    return animation;
}

- (void) clearmapView
{
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
}

- (void) clearSearch
{
    self.search.delegate = nil;
}

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] init];
    self.mapView.frame = self.view.bounds;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    [self initBackBtn];
    [self initLocBtn];
}

- (void) initBackBtn
{
    int i;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (kScreenHeight == 480) {
         i = 30;
    }else{
        i = 20;
    }
    backBtn.frame = CGRectMake(15, kScreenHeight *9 /10 - i, 30, 30);
    [backBtn addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.backgroundColor = [UIColor redColor];
    [backBtn setImage:[UIImage imageNamed:@"Previous_72px_1154207_easyicon.net"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
}


- (void) initLocBtn
{
    int i;
    if (kScreenHeight == 480) {
        i = 30;
    }else{
        i = 20;
    }
    UIButton *locBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locBtn.frame = CGRectMake(kScreenWidth - 45, kScreenHeight*9 /10 - i, 30, 30);
//    locBtn.backgroundColor = [UIColor redColor];
    [locBtn setImage:[UIImage imageNamed:@"aim_72px_1139273_easyicon.net"] forState:UIControlStateNormal];
    [locBtn addTarget:self action:@selector(locBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locBtn];
}

- (void) locBtnAction
{
    MACoordinateRegion region =  MACoordinateRegionMake(self.mapView.userLocation.location.coordinate, MACoordinateSpanMake(0.01, 0.01));
    [self.mapView setRegion:region animated:YES];
}


- (void) viewWillAppear:(BOOL)animated
{
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
}


- (void)initSearch
{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}


- (void) initSearchBar
{
    self.searchBar = self.searchController.searchBar;
    self.searchBar.delegate = self;
    self.searchBar.barStyle = UIBarStyleBlack;
    self.searchBar.frame = CGRectMake(0, 20, kScreenWidth, 44);
    [self.view addSubview:self.searchBar];
}

- (UISearchController *)searchController
{
    if (!_searchController) {
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        self.searchController.searchResultsUpdater = self;
        self.searchController.dimsBackgroundDuringPresentation = NO;
        [self.searchController.searchBar sizeToFit];
    }
    return _searchController;
}

#pragma mark--监听searchBar的状态
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (searchController.searchBar.text.length == 0) {
        [self.dataList removeAllObjects];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        return;
    }
    [self.dataList removeAllObjects];
    [self searchTipWith:searchController.searchBar.text];
    searchController.searchBar.placeholder = searchController.searchBar.text;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"base"];
    }
    if (self.dataList.count > indexPath.row) {
        cell.textLabel.text = self.dataList[indexPath.row];
    }
    return cell;
}

#pragma mark--点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.traffic.alpha = 1;
    self.map.alpha = 1;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.searchController setActive:NO];
    [self.mapView addAnnotation:self.annotationArr[indexPath.row]];
    MAPointAnnotation *annotation = self.annotationArr[indexPath.row];
    self.searchController.searchBar.placeholder = annotation.title;
    
    MACoordinateRegion region = MACoordinateRegionMake(annotation.coordinate, MACoordinateSpanMake(0.01, 0.01));
    [self.mapView setRegion:region animated:YES];
    self.tableView.hidden = YES;
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.dataList.count == 0) {
        return YES;
    }
    return NO;
}


#pragma mark--初始化tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableHeaderView = self.searchController.searchBar;

//        NSLog(@"%@",self.tableView.tableHeaderView);
        self.tableView.hidden = YES;
        [self.view addSubview:self.tableView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTap)];
        tap.delegate = self;
        [self.tableView addGestureRecognizer:tap];
    }
    return _tableView;
}

- (void) tableViewTap
{
    self.tableView.hidden = YES;
    [self.searchController setActive:NO];
}


#pragma mark--发送搜索
- (void) searchTipWith:(NSString *)tip
{
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.keywords = tip;
    
    if (self.city) {
        tipsRequest.city = self.city;
    }
    [self.search AMapInputTipsSearch:tipsRequest];
}

#pragma mark--数据源
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    self.traffic.alpha = 0;
    self.map.alpha = 0;
    if (response.tips.count == 0) {
        return;
    }
    
    //  设置annotion数组
    [self setAnnotationArrWithTips:response.tips];
    
    for (AMapTip *tip in response.tips) {
        [self.dataList addObject:tip.name];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark--searchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    self.traffic.alpha = 1;
    self.map.alpha = 1;
    [self.searchController setActive:NO];
    self.tableView.hidden = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.tableView.hidden = YES;
    self.traffic.alpha = 1;
    self.map.alpha = 1;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.tableView.hidden = NO;
    self.traffic.alpha = 0;
    self.map.alpha = 0;
    return YES;
}

#pragma mark--懒加载
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        self.dataList = [NSMutableArray array];
    }
    return _dataList;
}


#pragma mark--插旗
- (MAAnnotationView *) mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]] ) {
        return nil;
    }
    
     CustomAnnotationView *customView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"customView"];
    if (!customView) {
        customView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"customView"];
       
#pragma mark--点击callout控件
//        customView.calloutTap = ^()
//        {
//            [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
//                self.label.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
//            } completion:nil];
//        };
        
        customView.cancell = ^()
        {
            [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                self.label.frame = CGRectMake(0, kScreenHeight + 40, kScreenWidth, 40);
            } completion:nil];
        };
    customView.image = [UIImage imageNamed:@"pin_map_32px_1132440_easyicon.net"];
    }
    return customView;
}


- (NSMutableArray *)annotationArr
{
    if (!_annotationArr) {
        self.annotationArr = [NSMutableArray array];
    }
    return _annotationArr;
}

#pragma mark--处理插旗数据
- (void) setAnnotationArrWithTips:(NSArray *)tipsArr
{
    [self.annotationArr removeAllObjects];
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (AMapTip *tip in tipsArr) {
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
        annotation.title = tip.name;
        annotation.subtitle = tip.district;
        
        [self.mapView addAnnotation:annotation];
        [self.annotationArr addObject:annotation];
    }
    
}


- (void) initTrafficMap
{
    self.traffic = [UIButton buttonWithType:UIButtonTypeCustom];
    self.traffic.backgroundColor = [UIColor clearColor];
    self.traffic.frame = CGRectMake(kScreenWidth - 35, 60, 25, 50);
    [self.view addSubview:self.traffic];
    [self.traffic setImage:[UIImage imageNamed:@"traffic_32px_1180438_easyicon.net"] forState:UIControlStateNormal];
    [self.traffic addTarget:self action:@selector(trafficAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.map = [UIButton buttonWithType:UIButtonTypeCustom];
    //    map.backgroundColor = [UIColor blackColor];
    self.map.frame = CGRectMake(kScreenWidth - 35, 120, 30, 30);
    [self.view addSubview:self.map];
    [self.map setImage:[UIImage imageNamed:@"map_72px_1137905_easyicon.net"] forState:UIControlStateNormal];
    [self.map addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void) trafficAction:(UIButton *)trafficBtn
{
    if (!trafficBtn.selected) {
        [trafficBtn setImage:[UIImage imageNamed:@"traffic_32px_1180630_easyicon.net"] forState:UIControlStateNormal];
        trafficBtn.selected = !trafficBtn.selected;
        self.mapView.showTraffic = YES;
    }
    else{
        [trafficBtn setImage:[UIImage imageNamed:@"traffic_32px_1180438_easyicon.net"] forState:UIControlStateNormal];
        trafficBtn.selected = !trafficBtn.selected;
        self.mapView.showTraffic = NO ;
    }
}

- (void) mapAction:(UIButton *)mapBtn
{
    if (!mapBtn.selected) {
        [mapBtn setImage:[UIImage imageNamed:@"map_90px_1137574_easyicon.net"] forState:UIControlStateNormal];
        mapBtn.selected = !mapBtn.selected;
        self.mapView.mapType = !self.mapView.mapType;
    }
    else{
        [mapBtn setImage:[UIImage imageNamed:@"map_72px_1137905_easyicon.net"] forState:UIControlStateNormal];
        mapBtn.selected = !mapBtn.selected;
        self.mapView.mapType = !self.mapView.mapType;
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
