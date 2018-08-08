//
//  BCRechabilityVM.h
//  BatteryCam
//
//  Created by yf on 2018/6/29.
//  Copyright © 2018年 oceanwing. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const BC_NETWORK_UNKOWN;
extern NSString *const BC_NETWORK_NONE;
extern NSString *const BC_NETWORK_WWAN;
extern NSString *const BC_NETWORK_WIFI;
@interface BCRechabilityVM : NSObject
+(void)checkNetworkStatus;
+(NSString *)curNetworkStatus;
+(void)listenNetWorkingStatus2;
@end
