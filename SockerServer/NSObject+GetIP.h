//
//  NSObject+GetIP.h
//  SockerServer
//
//  Created by 张晓烨 on 2018/3/30.
//  Copyright © 2018年 张晓烨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (GetIP)

+ (NSString *)deviceIPAdress;//wifi下
+ (NSString *)getIPAddresses;//蜂窝数据下的IP地址
@end
