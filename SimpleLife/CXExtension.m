//
//  UIView+UIView_CXExtension.m
//  DoubleScrollViewDemo
//
//  Created by Jim Chan on 15/11/27.
//  Copyright © 2015年 Jim Chan. All rights reserved.
//

#import "CXExtension.h"

@implementation UIView (UIView_CXExtension)
//X
- (void)setX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}
- (CGFloat)x
{
    return self.frame.origin.x;
}

//Y
- (void)setY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}

//width
- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}
- (CGFloat)width
{
    return self.frame.size.width;
}

//height
- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
- (CGFloat)height
{
    return self.frame.size.height;
}

//centerX
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint point = self.center;
    point.x = centerX;
    self.center = point;
}
- (CGFloat)centerX
{
    return self.center.x;
}

//centerY
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint point = self.center;
    point.y = centerY;
    self.center = point;
}
- (CGFloat)centerY
{
    return self.center.y;
}

//size
- (void)setSize:(CGSize)size
{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}
- (CGSize)size
{
    return self.frame.size;
}

//origin
- (void)setOrigin:(CGPoint)origin
{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}
- (CGPoint)origin
{
    return self.frame.origin;
}

@end

@implementation UIScrollView (UIScrollView_CXExtension)

//offsetX
- (void)setOffsetX:(CGFloat)offsetX
{
    CGPoint point = self.contentOffset;
    point.x = offsetX;
    self.contentOffset = point;
}
- (CGFloat)offsetX
{
    return self.contentOffset.x;
}

//offsetY
- (void)setOffsetY:(CGFloat)offsetY
{
    CGPoint point = self.contentOffset;
    point.y = offsetY;
    self.contentOffset = point;
}
- (CGFloat)offsetY
{
    return self.contentOffset.y;
}

@end
