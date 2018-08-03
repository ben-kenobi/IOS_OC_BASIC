//
//  IUtil.h
//Created by apple on 17/07/21.
//

#import <UIKit/UIKit.h>

#define LoginNoti @"LoginNoti"
#define LogoutNoti @"LogoutNoti"
#define usernamekey @"usernamekey"
#define pwdkey @"pwdkey"
typedef enum : NSUInteger {
    BCHttpMethodGet,
    BCHttpMethodPost,
    BCHttpMethodPostJson,
    BCHttpMethodDelete,
    BCHttpMethodPut
} BCHttpMethod;


BOOL emptyStr(NSString *str);
BOOL nullObj(id obj);

@interface IUtil : NSObject
+(NSString *)getTimestamp;
+(void)broadcast:(NSString *)mes info:(NSDictionary *)info;
+(float)systemVersion;
+(NSInteger)appVersion;
+(NSString *)appVersionStr;

+(NSArray *)prosWithClz:(Class)clz;
+(NSArray *)varsWithClz:(Class)clz;
+(id)setValues:(NSDictionary *)dict forClz:(Class)clz;
//通过setter方法设置
+(id)setterValues:(NSDictionary *)dict forClz:(Class)clz;
//通过setter方法设置
+(void)setterValues:(NSDictionary *)dict forObj:(NSObject *)obj;
+(void)setValues:(NSDictionary *)dict forObj:(NSObject *)obj;

+(NSArray *)aryWithClz:(Class)clz fromFile:(NSString *)file;


+(void)postSystemwideNoti:(NSString *)notiname;


/**
 添加系统级的广播监听
 @param name 广播名
 @param cb 回调，需要外部保持强引用，并且需要在不需要的时候 removeSystemwideObserver
 */
+(void)observeSystemwideNoti:(NSString *)name cb:(void (^)(void))cb;
+(void)removeSystemwideObserver:(id)observer;

+(NSData *)uploadBodyWithBoundary:(NSString *)boundary file:(NSString *)file  name:(NSString *)name filename:(NSString *)filename;
+(NSURLResponse *)synResponseByURL:(NSURL *)url;

+(void)uploadFile:(NSString *)file name:(NSString *)name
         filename:(NSString *)filename toURL:(NSURL *)url callBack:(void (^)(NSData *data,NSURLResponse *response, NSError *error))callback;
+(void)upload:(NSData *)data name:(NSString *)name
     filename:(NSString *)filename toURL:(NSURL *)url setupReq:(void(^)(NSMutableURLRequest *req))setupReq callBack:(void (^)(NSData *data,NSURLResponse *response, NSError *error))callback;

+(void)multiUpload:(NSArray *)contents toURL:(NSURL *)url callBack:(void (^)(NSData *data,NSURLResponse *response, NSError *error))callback;


+(void)post:(NSURL *)url body:(NSString *)body callBack:(void (^)(NSData *data,NSURLResponse *response, NSError *error))callback;
+(void)get:(NSURL *)url cache:(int)cache callBack:(void (^)(NSData *data,NSURLResponse *response, NSError *error))callback;



+ (NSInteger)availableMemory;

+ (NSInteger)usedMemory;
+ (double)curUsage;
+(double)GetCpuUsage ;
+ (NSInteger)GetMemoryStatistics ;




#pragma mark - from cate

NSLocale * prefLocale(void);
NSString * localeLanguage(void);
NSString * localeCountry(void);
NSInteger  timeOffset(void);//时差，单位秒

NSTimer * iTimer(CGFloat inteval,id tar,SEL sel,id userinfo);

CADisplayLink *iDLink(id tar,SEL sel);
void runOnMain(void (^blo)(void));
void runOnGlobal(void (^blo)(void));

NSString * iphoneType(void) ;
BOOL isRightToLeft(void);

@end
