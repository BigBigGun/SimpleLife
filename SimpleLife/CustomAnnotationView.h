//
//  CustomAnnotation.h
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/5.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>


@class CalloutView;



@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, readonly) CalloutView *calloutView;
@property (nonatomic, strong) UILabel *label;



@property (nonatomic, copy) void (^calloutTap)();

@property (nonatomic, copy) void (^cancell)();

@end
