//
//  MyView.h
//  SimpleLife
//
//  Created by 陆俊伟 on 15/12/7.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyView1 : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

+ (instancetype) initMyView;


@end
