

//
//  BCExtensionHttpClient.m
//  BatteryCam
//
//  Created by yf on 2018/6/26.
//  Copyright © 2018年 oceanwing. All rights reserved.
//

#import "BCBaseHttpClient.h"
#import "IUtil.h"

NSInteger const BC_NETWORKERR=-9999;


NSString *const baseurl_us=@"security-app.eufylife.com";
NSString *const baseurl_eu=@"security-app-eu.eufylife.com";
NSString *const baseurl_test=@"security-app-qa.eufylife.com";
NSString *const baseurl_ci=@"security-app-ci.eufylife.com";

NSString *BaseUrlPrefSuitName=@"group.batterycam";

#ifdef DEBUG
//QA

static NSString * const BCBASEURL = baseurl_us;

//CI

static NSURLRequestCachePolicy CACHEPOLICY=NSURLRequestReloadIgnoringLocalCacheData;
static NSInteger TIMEOUT=10;
#else

static NSString * const BCBASEURL = baseurl_us;
static NSURLRequestCachePolicy CACHEPOLICY=NSURLRequestUseProtocolCachePolicy;
static NSInteger TIMEOUT=15;

#endif


@implementation BCBaseHttpClient

#pragma mark - upload
//==========uploade===================
+(void )upload:(NSString *)url formdata:(NSData *)data param:(NSDictionary *)param callBack:(void (^)(NSInteger code, id data, NSString* msg))callback{
    static  NSDateFormatter *fm;
    if(!fm){
        fm=[[NSDateFormatter alloc] init];
        fm.dateFormat=@"yyyyMMddHHmmss";
    }
    NSString *avatarsufix = [fm stringFromDate:[NSDate date]];
    [IUtil upload:data name:@"avatar" filename:iFormatStr(@"avatar%@",avatarsufix) toURL:iURL([self fullUrl:url]) setupReq:^(NSMutableURLRequest *req) {
        [self setupCommonHearder:req];
        
        
    } callBack:^(NSData *rawdata, NSURLResponse *response, NSError *error) {
        if(error){
            NSString *str = [self handleError:error code:((NSHTTPURLResponse *)response).statusCode];
            if(callback)
                callback(BC_NETWORKERR,nil,str);
        }else{
            NSInteger code=-1;
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:rawdata options:0 error:nil];
            NSString *msg = [self parseBCResponseCode:data url:url code:&code];
            if(callback)
                callback(code,data,msg);
        }
    }];
}
+(NSURLSessionUploadTask *)mulitiUpload:(NSString *)url files:(NSArray<NSString *> *)files datas:(NSArray<NSData *>*)datas param:(NSDictionary *)param callBack:(void (^)(NSInteger code, id data, NSString* msg))callback prog:(void(^)(NSProgress *prog))progcb{
    //将字典参数转换成json数据，放入key为body的数据段
    NSDictionary * dict=@{@"body":[NSJSONSerialization dataWithJSONObject:param options:0 error:0] };
    //创建multipartRequest
    NSMutableURLRequest *request=[[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[self fullUrl:url] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //将文件拼接于表单数据段
            //            [formData appendPartWithFileURL:[NSURL fileURLWithPath:obj] name:@"files[]" error:0];
            [formData appendPartWithFileData:iData4F(obj) name:@"files[]" fileName:obj.lastPathComponent mimeType:@""];
        }];
        [datas enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:obj name:@"files[]" fileName:@"XXX" mimeType:@""];
        }];
    } error:nil];
    [request setTimeoutInterval:TIMEOUT];
    [self setupCommonHearder:request];
    
    
    //处理回调block
    void (^cb)(NSURLResponse *,id , NSError *) = ^(NSURLResponse *response,id data, NSError *error){
        if(error){
            NSString *str = [self handleError:error code:((NSHTTPURLResponse *)response).statusCode];
            if(callback)
                callback(BC_NETWORKERR,nil,str);
        }else{
            NSInteger code=-1;
            NSString *msg = [self parseBCResponseCode:data url:url code:&code];
            if(callback)
                callback(code,data,msg);
        }
    };
    //使用uploadTaskWithStreamedRequest方法上传
    NSURLSessionUploadTask *task=[BCBaseHttpClient.shared uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progcb)
            progcb(uploadProgress);
    } completionHandler:cb];
    [task resume];
    return task;
    
}


#pragma mark - BCProject network interfaces
//--------------BCProject network interfaces ------
+(NSURLSessionTask *)bcJsonPost:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSInteger code, id data, NSString* msg))callback{
    return [self bcHttpMethod:BCHttpMethodPostJson url:url param:param callBack:callback];
}
+(NSURLSessionTask *)bcPost:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSInteger code, id data,NSString* msg))callback{
    return [self bcHttpMethod:BCHttpMethodPost url:url param:param callBack:callback];
    
}
+(NSURLSessionTask *)bcGet:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSInteger code, id data,NSString* msg))callback{
    return [self bcHttpMethod:BCHttpMethodGet url:url param:param callBack:callback];
}
+(NSURLSessionTask *)bcDelete:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSInteger code, id data,NSString* msg))callback{
    return [self bcHttpMethod:BCHttpMethodDelete url:url param:param callBack:callback];
}
+(NSURLSessionTask *)bcPut:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSInteger code, id data,NSString* msg))callback{
    return [self bcHttpMethod:BCHttpMethodPut url:url param:param callBack:callback];
}


+(NSURLSessionTask *)bcHttpMethod:(BCHttpMethod)method url:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSInteger code, id data,NSString* msg))callback{
    void (^cb)(NSURLResponse *,id , NSError *) = ^(NSURLResponse *response,id data, NSError *error){
        if(error){
            NSString *str = [self handleError:error code:((NSHTTPURLResponse *)response).statusCode];
            if(callback)
                callback(BC_NETWORKERR,nil,str);
        }else{
            NSInteger code=-1;
            NSString *msg = [self parseBCResponseCode:data url:url code:&code];
            if(callback)
                callback(code,data,msg);
        }
    };
    NSURLSessionTask * task = nil;
    switch (method) {
        case BCHttpMethodGet:
            task=[self get:url param:param callBack:cb];
            break;
        case BCHttpMethodPost:
            task=[self post:url param:param callBack:cb];
            break;
        case BCHttpMethodPostJson:
            task=[self jsonPost:url param:param callBack:cb];
            break;
        case BCHttpMethodDelete:
            task=[self delete:url param:param callBack:cb];
            break;
        case BCHttpMethodPut:
            task=[self put:url param:param callBack:cb];
            break;
        default:
            break;
    }
    return task;
}




#pragma mark - Basic interfaces
//---------------Basic interfaces-------
+ (instancetype)shared{
    static BCBaseHttpClient *instance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        //        instance.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        instance.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [instance.securityPolicy setAllowInvalidCertificates:YES];
        [instance.securityPolicy setValidatesDomainName:NO];
    });
    return instance;
}


+(NSURLSessionTask *)jsonPost:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSURLResponse *response,id data, NSError *error))callback{
    BCBaseHttpClient *client = [BCBaseHttpClient shared];
    NSMutableURLRequest *request=[[AFJSONRequestSerializer serializer]requestWithMethod:@"POST" URLString:[self fullUrl:url] parameters:param error:nil];
    [request setTimeoutInterval:TIMEOUT];
    [self setupCommonHearder:request];
    
    NSURLSessionTask *task = [client dataTaskWithRequest:request completionHandler:callback];
    [task resume];
    return task;
}

+(NSURLSessionTask *)put:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSURLResponse *response,id data, NSError *error))callback{
    BCBaseHttpClient *client = [BCBaseHttpClient shared];
    NSMutableURLRequest *request=[[AFJSONRequestSerializer serializer]requestWithMethod:@"PUT" URLString:[self fullUrl:url] parameters:param error:nil];
    [request setCachePolicy:CACHEPOLICY];
    [request setTimeoutInterval:TIMEOUT];
    [self setupCommonHearder:request];
    
    NSURLSessionTask *task = [client dataTaskWithRequest:request completionHandler:callback];
    [task resume];
    return task;
}

+(NSURLSessionTask *)delete:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSURLResponse *response,id data, NSError *error))callback{
    BCBaseHttpClient *client = [BCBaseHttpClient shared];
    //    NSMutableURLRequest *request=[[AFJSONRequestSerializer serializer]requestWithMethod:@"DELETE" URLString:[self fullUrl:url] parameters:param error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:iURL([self fullUrl:url]) cachePolicy:CACHEPOLICY timeoutInterval:TIMEOUT];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [NSJSONSerialization dataWithJSONObject:param options:0 error:0]];
    [self setupCommonHearder:request];
    
    NSURLSessionTask *task = [client dataTaskWithRequest:request completionHandler:callback];
    [task resume];
    return task;
}



+(NSURLSessionTask *)post:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSURLResponse *response,id data, NSError *error))callback{
    BCBaseHttpClient *client = [BCBaseHttpClient shared];
    NSMutableURLRequest *request=[[AFHTTPRequestSerializer serializer]requestWithMethod:@"POST" URLString:[self fullUrl:url] parameters:param error:nil];
    [request setTimeoutInterval:TIMEOUT];
    [self setupCommonHearder:request];
    
    NSURLSessionTask *task = [client dataTaskWithRequest:request completionHandler:callback];
    [task resume];
    return task;
}
+(NSURLSessionTask *)get:(NSString *)url param:(NSDictionary *)param callBack:(void (^)(NSURLResponse *response,id data, NSError *error))callback{
    BCBaseHttpClient *client = [BCBaseHttpClient shared];
    NSMutableURLRequest *request=[[AFHTTPRequestSerializer serializer]requestWithMethod:@"GET" URLString:[self fullUrl:url] parameters:param error:nil];
    [request setCachePolicy:CACHEPOLICY];
    [request setTimeoutInterval:TIMEOUT];
    [self setupCommonHearder:request];
    NSURLSessionTask *task = [client dataTaskWithRequest:request completionHandler:callback];
    [task resume];
    return task;
}


//优先使用手动选择，为空则使用auto地址，最后使用默认地址
+(NSString *)fullUrl:(NSString *)url{
    if([url hasPrefix:@"http://"]||[url hasPrefix:@"https://"])
        return url;
    NSString *baseurl=[self prefServerPath];
    if(!baseurl)
        baseurl=BCBASEURL;
    return [NSString stringWithFormat:@"https://%@/v1/%@",baseurl,url];
}

+(void)setOnNetworkStatusChange:(void (^)(BOOL wifi,BOOL cellular))cb{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if(cb)
            cb(status==AFNetworkReachabilityStatusReachableViaWiFi,status==AFNetworkReachabilityStatusReachableViaWWAN);
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}



+(void)setupCommonHearder:(NSMutableURLRequest *)request{
    [request setValue:[IUtil appVersionStr] forHTTPHeaderField:@"app_version"];
    [request setValue:@"IOS" forHTTPHeaderField:@"os_type"];
    [request setValue:[UIDevice currentDevice].systemVersion forHTTPHeaderField:@"os_version"];
    [request setValue:[IUtil deviceUUId] forHTTPHeaderField:@"openudid"];
    [request setValue:[prefLocale() objectForKey:NSLocaleLanguageCode] forHTTPHeaderField:@"language"];
    [request setValue:[prefLocale() objectForKey:NSLocaleCountryCode] forHTTPHeaderField:@"country"];
    [request setValue:iphoneType() forHTTPHeaderField:@"phone_model"];
    [request setValue: [AFNetworkReachabilityManager.sharedManager localizedNetworkReachabilityStatusString] forHTTPHeaderField:@"net_type"];
    //    [request setValue:@"null" forHTTPHeaderField:@"uid"];
    //    [request setValue:@"AppStore" forHTTPHeaderField:@"chid"];
    //    [request setValue:@"null" forHTTPHeaderField:@"mnc"];
    //    [request setValue:@"null" forHTTPHeaderField:@"mcc"];
    //    [request setValue:LOG_PRODUCT_NAME forHTTPHeaderField:@"ignore_sn"];
    NSString *abbreviation = [NSTimeZone systemTimeZone].abbreviation;
    [request setValue:abbreviation forHTTPHeaderField:@"timezone"];
    [request setValue:[NSString stringWithFormat:@"%ld",timeOffset()] forHTTPHeaderField:@"timeOffset"];
}









/**
 0 成功
 -1 失败
 应用服务器的错误码
 // common response code
 const (
 CodeOk = 0 // 成功
 CodeInputParamInvalid = 10000
 CodeInputJSONInvalid = 10001
 CodeDataMissing = 10002
 CodeReadDbFailed = 10003
 CodeWriteDbFailed = 10004
 CodeSendEmailFailed = 10005
 CodeInvalidFileData = 10006
 CodeQueryFailed = 10007
 CodeFileUploadFailed = 10008
 CodeTransferFileFailed = 10009
 CodeInvalidSession = 10010
 CodeNotImplement = 10011
 CodeInvalidKey = 10012
 )
 
 // equipment response code
 const (
 CodeStationNotExist = 20000
 CodeStationExist = 20001
 CodeStationBinded          = 20002
 CodeStationNotBinded       = 20003
 CodeStationNotAdmin        = 20004
 CodeDeviceBinded           = 20005
 CodeDeviceBindedToAnother  = 20006
 CodeDeviceNotBinded        = 20007
 CodeDeviceNotExist         = 20008
 CodeDeviceExist            = 20009
 CodeStationNotReset        = 20010
 CodeDeviceNotAdmin         = 20011
 CodeStationAllocated       = 20012
 CodeRunOutOfDid            = 20013
 CodeDidExist               = 20014
 CodeDeviceAllocated        = 20015
 CodeRunOutOfRtsp           = 20016
 CodeRtspExist              = 20017
 CodeDidServerExist         = 20018
 CodeDidServerNotExist      = 20019
 CodeStationBindedToAnother = 20020
 )
 
 // monitor response code
 const (
 CodeEventNotExist = 21000
 CodeEventNotAuth = 21001
 CodeEventFavorited = 21002
 CodeEventNotFavorited = 21003
 CodeEventPartialNotExist = 21004
 )
 
 // family response code
 const (
 CodeStationMemberExist = 22000
 CodeStationMemberNotExist = 22001
 CodeStationSuperAdmin = 22002
 CodeStationDeviceNotExist = 22003
 CodeStationMemberInvited = 22004
 CodeStationMemberNotInvited = 22005
 CodeStationNotSuperAdmin = 22006
 CodeUnauthorizeSelf = 22007
 )
 
 // cloud response code
 const (
 CodeStorageNotOpen = 24000
 CodeUserNoTiral = 24001
 CodeStorageOpened = 24002
 CodeStorageExpired = 24003
 CodePackageNotExist = 24004
 )
 
 // order response code
 const (
 CodeOrderNotExistOrExpired = 25000
 CodeOrderNotCreated = 25001
 CodeOrderNotPayed = 25002
 CodeOrderChargeFailed = 25003
 CodeOrderRefundFailed = 25004
 CodeOrderChargeSuccDbFailed = 25005
 CodeOrderRefundSuccDbFailed = 25006
 )
 
 // passport response code
 const (
 CodeRegisterFailed = 26000
 CodeValidateEmailFailed = 26001
 CodeActivateFailed = 26002
 CodeForgetPasswordFailed = 26003
 CodeChangePasswordFailed = 26004
 CodeThirdPartyLoginFailed = 26005
 CodeLoginFailed = 26006
 CodeAutoLoginFailed = 26007
 CodeGetProfileFailed = 26008
 CodeSubscribeEmailsFailed = 26009
 CodeUpdateProfileFailed = 26010
 CodeEditAvatarFailed = 26011
 CodeUserNotExist = 26012
 CodeResetPasswordFailed = 26013
 )
 
 // notification response code
 const (
 CodeStationNotConnected = 27000
 )
 
 // admin response code
 const (
 CodeAdminUserNotExist = 28000
 CodeSetSessionFailed = 28001
 CodeDeleteSessionFailed = 28002
 CodeNotSuperAdmin = 28003
 CodeAdminUserExist = 28004
 CodeModifyPasswordFailed = 28005
 CodeDeleteUsersFailed = 28006
 CodeUndeleteUsersFailed = 28007
 )
 
 // aiassis response code
 const (
 CodeAiAssisGroupNotExist = 29000
 CodeAiAssisGroupExist = 29001
 CodeAiAssisDeleteGroupsFailed = 29002
 CodeAiAssisUserNotExist = 29003
 CodeAiAssisUserExist = 29004
 CodeAiAssisDeleteUsersFailed = 29005
 CodeAiAssisMonitorFaceNotExist = 29006
 )
 
 // feedback response code
 const (
 CodeGeneralCreateFailed = 30000
 )
 
 // tcp response code
 const (
 CodeInvalidStation = 40000
 CodeSaveStationFailed = 40001
 CodeConnectionNotExist = 40002
 CodeTransferFailed = 40003
 )
 
 */

+(NSString *)parseBCResponseCode:(NSDictionary *)dict url:(NSString *)url code:(NSInteger *)outcode{
    NSString *msg = dict[@"msg"];
    NSInteger code = [dict[@"code"]integerValue];
    *outcode =code;
    printf("\n---response begin----url = %s----\ncode=%ld,msg=%s\n----------response end---------------------\n",[url UTF8String],code,[msg UTF8String]);
    return msg;
}
+(NSString *)handleError:(NSError *)err code:(NSInteger)code{
    if(err.code==-999)return nil;
    NSString *desc=[err.userInfo[@"NSUnderlyingError"] description] ;
    printf("\n--------err begin----------\n%s\n%s\n----------err end---------------------\n",[err.userInfo[@"NSLocalizedDescription"] UTF8String],[(desc.length>200?[desc substringToIndex:200]:desc) UTF8String]);
    //    return [NSString stringWithFormat:@"%ld",err.code];
    NSString *errstr =  err.userInfo[@"NSLocalizedDescription"];
    if([errstr containsString:@"A server with the specified hostname could not be found."]){
        return NSLocalizedString(@"Can't connect to the backend. Please try again later.", 0);
    }
    return errstr;
}





#pragma mark - serverPath
/**
 selected:按照手动选择的区域判断服务器地址
 auto:按照查询区域返回的地区判断服务器地址
 serverSpecify:默认服务器指定的域名
 //优先使用手动选择，为空则使用auto地址，还空则使用默认的服务器指定的域名
 在没有选中的服务器地址时,则登录完后查询服务器一次
 */
+(NSString *)prefServerPath{
    NSString *path = [self selectedServerPath];
    if(emptyStr(path))
        path = [self autoServerPath];
    if(emptyStr(path))
        path = [self serverSpecifiedPath];
    return path;
}
+(NSString *)selectedServerPath{
    return [iPref(BaseUrlPrefSuitName) stringForKey:@"selectedServerPath"];
}
+(NSString *)autoServerPath{
    return [iPref(BaseUrlPrefSuitName) stringForKey:@"autoServerPath"];
}
+(void)setSelectdServerPath:(NSString *)path{
    [iPref(BaseUrlPrefSuitName) setObject:path forKey:@"selectedServerPath"];
    [iPref(BaseUrlPrefSuitName) synchronize];
}
+(void)setAutoServerPath:(NSString *)path{
    [iPref(BaseUrlPrefSuitName) setObject:path forKey:@"autoServerPath"];
    [iPref(BaseUrlPrefSuitName) synchronize];
}

//只在select为空的时候才查询获取auto地址，所以auto地址需要设置给select和auto两个key
+(void)setAutoServerPathBy:(NSString *)couCode{
    NSString *url = nil;
    if([couCode.uppercaseString isEqualToString:@"US"]){
        url=baseurl_us;
    }else if([couCode.uppercaseString isEqualToString:@"HK"]){
        url=baseurl_test;
    }else if([couCode.uppercaseString isEqualToString:@"EU"]){
        url=baseurl_eu;
    }
    [self setSelectdServerPath:url];
    [self setAutoServerPath:url];
}
+(NSString *)serverSpecifiedPath{
    return nil;
}

@end
