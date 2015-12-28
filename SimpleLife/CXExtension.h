//
//  UIView+UIView_CXExtension.h
//  DoubleScrollViewDemo
//
//  Created by Jim Chan on 15/11/27.
//  Copyright © 2015年 Jim Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//颜色
#define kColor(r,g,b) kAlphaColor(r,g,b,1)
#define kAlphaColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kGrayColor(gray) kGrayAlphaColor(gray,1)
#define kGrayAlphaColor(g,a) [UIColor colorWithWhite:g alpha:a]

@interface UIView (UIView_CXExtension)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGSize size;
@property (nonatomic) CGPoint origin;

@end

@interface UIScrollView (UIScrollView_CXExtension)

@property (nonatomic) CGFloat offsetX;
@property (nonatomic) CGFloat offsetY;

@end