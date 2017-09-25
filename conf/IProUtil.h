//
//  iProUtil.h
//  day39-project01
//
//  Created by apple on 15/11/22.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


CGFloat dp2po(CGFloat dp);
@interface IProUtil : NSObject<CLLocationManagerDelegate>
+(void)commonPrompt:(NSString *)title msg:(NSString *)msg cb:(void(^)())cb;
+(void)prompt:(NSString *)title tcolor:(UIColor *)tcolor tfont:(UIFont*)tfont msg:(NSString *)msg mcolor:(UIColor *)mcolor mfont:(UIFont *)mfont cb:(void(^)())cb;
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


@end

