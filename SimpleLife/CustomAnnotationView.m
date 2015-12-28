//
//  CustomAnnotation.m
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/5.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CalloutView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface CustomAnnotationView ()

@property (nonatomic, strong, readwrite) CalloutView *calloutView;

@end

#define kCalloutWidth       200.0
#define kCalloutHeight      70.0

@implementation CustomAnnotationView

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            self.calloutView = [[CalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.
                                                    calloutOffset.y);
//            __block CustomAnnotationView *customView = self;
////            __weak __typeof(self)weakSelf = self;
//            self.calloutView.calloutTapAction = ^()
//            {
//                  customView.calloutTap();
//            };
        }
        
        self.calloutView.image = [UIImage imageNamed:@"Picture_JPG_96px_1163304_easyicon.net"];
        self.calloutView.title = self.annotation.title;
        self.calloutView.subtitle = self.annotation.subtitle;
        
        
        
        [self addSubview:self.calloutView];
    }
    else
    {
        self.cancell();
        [self.calloutView removeFromSuperview];
    }
     [super setSelected:selected animated:animated];
   
}





@end
