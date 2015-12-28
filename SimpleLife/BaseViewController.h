//
//  BaseViewController.h
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/4.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MyView1.h"
#import "CustomAnnotationView.h"


@interface BaseViewController : UIViewController <MAMapViewDelegate,AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) MyView1 *label;
@property (nonatomic, strong) NSString *city;


- (void)returnAction;

@end
