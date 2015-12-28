//
//  CalloutView.h
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/5.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalloutViewDelegate <NSObject>

@optional
- (void) calloutTapAction;

@end

@interface CalloutView : UIView

//@property (nonatomic, weak) id<CalloutViewDelegate> delegate;

@property (nonatomic, copy) void (^calloutTapAction)();

@property (nonatomic, strong) UIImage *image; //商户图
@property (nonatomic, copy) NSString *title; //商户名
@property (nonatomic, copy) NSString *subtitle; //地址

@end



