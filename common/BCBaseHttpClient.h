//
//  BCExtensionHttpClient.h
//  BatteryCam
//
//  Created by yf on 2018/6/26.
//  Copyright © 2018年 oceanwing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
extern NSInteger const BC_NETWORKERR;

extern NSString *const baseurl_us;
extern NSString *const baseurl_eu;
extern NSString *const baseurl_test;
extern NSString *const baseurl_ci;
extern NSString *BaseUrlPrefSuitName;

@interface BCBaseHttpClient : AFHTTPSessionManager
+ (instancetype)shared;
+(NSURLSessionTask *)bcJsonPost:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSInteger code, id data, NSString* msg))callback;
+(NSURLSessionTask *)bcPost:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSInteger code, id data,NSString* msg))callback;
+(NSURLSessionTask *)bcGet:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSInteger code, id data,NSString* msg))callback;
+(NSURLSessionTask *)bcDelete:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSInteger code, id data,NSString* msg))callback;
+(NSURLSessionTask *)bcPut:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSInteger code, id data,NSString* msg))callback;

+(void)upload:(NSString *)url formdata:(NSData *)data param:(NSDictionary *)param callBack:(void (^)(NSInteger code, id data, NSString* msg))callback;

+(NSURLSessionUploadTask *)mulitiUpload:(NSString *)url files:(NSArray<NSString *> *)files  datas:(NSArray<NSData *>*)datas param:(NSDictionary *)param callBack:(void (^)(NSInteger code, id data, NSString* msg))callback prog:(void(^)(NSProgress *prog))progcb;



#pragma mark - override by subclass
+(void)setupCommonHearder:(NSMutableURLRequest *)request;
+(NSString *)handleError:(NSError *)err code:(NSInteger)code;

#pragma mark - serverPath
+(void)setSelectdServerPath:(NSString *)path;
+(NSString *)selectedServerPath;
+(void)setAutoServerPathBy:(NSString *)couCode;
@end
