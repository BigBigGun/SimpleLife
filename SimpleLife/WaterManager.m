//
//  WaterManager.m
//  SimpleLife
//
//  Created by 陆俊伟 on 15/11/30.
//  Copyright © 2015年 陆俊伟. All rights reserved.
//

#import "WaterManager.h"

@implementation WaterManager

+ (instancetype) shareManager
{
    static WaterManager *water = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!water) {
            water = [[WaterManager alloc] init];
        }
    });
    return water;
}

//- (void)writeIntoPlist:(id)value andKey:(NSString *)key
//{
//    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Setting.plist"];
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
//    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
//    [dic1 setObject:value forKey:key];
//}

@end
