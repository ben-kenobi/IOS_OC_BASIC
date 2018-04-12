//
//  iProUtil.h
//  day39-project01
//
//  Created by apple on 15/11/22.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BCAlertStylesheetVC.h"

CGFloat dp2po(CGFloat dp);
@interface IProUtil : NSObject<CLLocationManagerDelegate>
+(void)commonPrompt:(NSString *)title msg:(NSString *)msg cb:(void(^)(void))cb;
+(void)prompt:(NSString *)title tcolor:(UIColor *)tcolor tfont:(UIFont*)tfont msg:(NSString *)msg mcolor:(UIColor *)mcolor mfont:(UIFont *)mfont cb:(void(^)(void))cb;
+(void)prompt:(NSString *)title tcolor:(UIColor *)tcolor tfont:(UIFont*)tfont msg:(NSString *)msg mcolor:(UIColor *)mcolor mfont:(UIFont *)mfont vc:(UIViewController *)fromVC cb:(void(^)(void))cb;
+(UIAlertController *)commonTextFieldDialog:(NSString*)title msg:(NSString *)msg ph:(NSString *)ph text:(NSString *)text cb:(void (^)(BOOL isOK,NSString *text))cb;
+(void)prompt:(NSAttributedString *)msg cb:(void(^)(void))cb;
+(void)sheetPrompt:(id<BCStyleSheetListDelegate>)datas vc:(UIViewController *)fromVC;
+(void)locationWith:(void(^)(BOOL suc,NSArray *locs))cb;
+(instancetype)shareInstance;
+(NSString *)digestAry:(NSArray *)ary;
+(NSString *)digestStr:(NSString *)str;
+(UIButton *)btnWith:(CGRect)frame title:(NSString *)title bgc:(UIColor *)bgc font:(UIFont *)font sup:(UIView *)sup;
+(UILabel*)labWithColor:(UIColor*)color font:(UIFont *)font sup:(UIView *)sup;
+(NSRegularExpression *)usernameRe;
+(NSRegularExpression *)pwdRe;
+(NSRegularExpression *)mobileRe;

+(NSString *)durationFormat:(NSInteger)sec;

+(UILabel *)commonLab:(UIFont *)font color:(UIColor *)color;
+(UIButton *)commonTextBtn:(UIFont *)font color:(UIColor *)color title:(NSString *)title;
+(UILabel *)commonLab:(UIFont *)font color:(UIColor *)color bg:(UIColor *)bg;
+(BOOL)isEmail:(NSString *)str;
+(BOOL)isLoginPwd:(NSString*)str;
+(BOOL)isSignupPwd:(NSString*)str;

+(NSString *)getDeviceId;
+(NSDictionary *)attrDictWith:(UIColor *)fcolor font:(UIFont *)font;
+(UIImageView *)commonLoadingIv;
+(void)dispatchAfter:(CGFloat)secs tar:(id)tar bloc:(void(^)(void))bloc;
+(void)dispatchCancel:(id)tar;
@end

