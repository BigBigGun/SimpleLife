//
//  ToiletController.m
//  SimpleLife
//
//  Created by 陆俊伟 on 15/11/30.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//


#import "ToiletController.h"
#import <MAMapKit/MAMapKit.h>
#import <AVFoundation/AVFoundation.h>


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ToiletController ()

@property (nonatomic) CLLocationCoordinate2D userloc;
@property (nonatomic) NSMutableArray *annotationArr1;


@end

@implementation ToiletController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.searchController.searchBar.placeholder = @"厕所";
    [self.mapView.userLocation addObserver:self forKeyPath:@"location" options:NSKeyValueObservingOptionNew context:nil];
    self.mapView.showsCompass = YES;
    self.mapView.showsScale = YES;
    self.mapView.compassOrigin = CGPointMake(self.mapView.compassOrigin.x, 84);

}



- (void) initSearcher
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:self.userloc.latitude longitude:self.userloc.longitude];
    request.keywords = @"公共厕所";
    request.types = @"公共设施";
    request.sortrule = 0;
    request.requireExtension = YES;
    [self.search AMapPOIAroundSearch:request];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([object isKindOfClass:[MAUserLocation class]]) {
        CLLocation *userloc = change[@"new"];
        self.userloc = userloc.coordinate;
        [self initReGeo];
        [self.mapView setRegion:MACoordinateRegionMake(self.userloc, MACoordinateSpanMake(0.02, 0.02)) animated:YES];
        [self initSearcher];
        if (self.mapView.userLocation.location) {
            [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];

        }
    }
}




//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    [self setAnnotationArrWithPois:[NSMutableArray arrayWithArray:response.pois]];
}

#pragma mark--处理插旗数据
- (void) setAnnotationArrWithPois:(NSArray *)poisArr
{
    [self.annotationArr1 removeAllObjects];
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (AMapPOI *pois in poisArr) {
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(pois.location.latitude, pois.location.longitude);
        annotation.title = pois.name;
        annotation.subtitle = pois.address;
        [self.mapView addAnnotation:annotation];
        [self.annotationArr1 addObject:annotation];
    }
}

#pragma mark--反编码
- (void) initReGeo
{
    AMapReGeocodeSearchRequest *reGeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    reGeoRequest.location = [AMapGeoPoint locationWithLatitude:self.userloc.latitude longitude:self.userloc.longitude];
    reGeoRequest.radius = 10000;
    reGeoRequest.requireExtension = YES;
    [self.search AMapReGoecodeSearch:reGeoRequest];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    self.city = response.regeocode.addressComponent.city;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.label.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
        self.label.nameLabel.text = view.annotation.title;
        self.label.addressLabel.text = view.annotation.subtitle;
    } completion:nil];
    [self.mapView setRegion:MACoordinateRegionMake(view.annotation.coordinate, self.mapView.region.span) animated:YES];
}

-(void)dealloc
{
    if (!self.mapView.userLocation.location) {
        [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
    }
}


- (void)customVoice:(id)sender {
    
    //Get the filename of the sound file:
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/drink.mp3"];
//    NSLog(@"%@",path);
    
    //declare a system sound
    SystemSoundID soundID ;
    
    //Get a URL for the sound file
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    //Use audio sevices to create the sound
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    //Use audio services to play the sound
    AudioServicesPlaySystemSound(soundID);
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