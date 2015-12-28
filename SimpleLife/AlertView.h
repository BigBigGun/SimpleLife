//
//  AlertView.h
//  SimpleLife
//
//  Created by 陆俊伟 on 15/11/30.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  AlertViewDelegate <NSObject>

- (void) btnDidTap:(UIButton *)btn;

@end

@interface AlertView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *heart;
@property (weak, nonatomic) IBOutlet UIButton *weightButton;

@property (weak, nonatomic) IBOutlet UIButton *activity;
@property (weak, nonatomic) IBOutlet UILabel *drinkQuantity;

@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *certain;
@property (nonatomic) float styleId;

//@property (nonatomic) float bottleSize;

@property (nonatomic, weak) id<AlertViewDelegate> delegate;

+ (instancetype) shareAlertView;

- (void) totalWater;

- (void) writeInPlist;

- (void) loadFromPlist;


@end
