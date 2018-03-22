//
//  UIUtil.h
//  BatteryCam
//
//  Created by yf on 2017/9/13.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MJRefreshBackNormalFooter,MJRefreshNormalHeader;
@interface BCSlider:UISlider
@end

@interface UIUtil : NSObject
+(void)commonShadow:(UIView *)view opacity:(CGFloat)opacity;
+(void)commonShadowWithRadius:(NSInteger)rad view:(UIView *)view opacity:(CGFloat)opacity;
+(void)commonShadowWithRadius:(NSInteger)rad size:(CGSize)size view:(UIView *)view opacity:(CGFloat)opacity;
+(void)commonShadowWithColor:(UIColor*)color Radius:(NSInteger)rad size:(CGSize)size view:(UIView *)view opacity:(CGFloat)opacity;
+(void)commonAnimation:(void (^)(void))cb;
+(void)commonAnimationWithDuration:(CGFloat)dura cb:(void (^)(void))cb;
+(void)commonAnimationWithDuration:(CGFloat)dura cb:(void (^)(void))cb comp:(void (^)(BOOL finish))comp;

+(void)commonUnderlineBtnSetup:(UIButton *)btn;
+(void)commonUnderlineBtnSetup:(UIButton *)btn title:(NSString *)title;
+(void)commonUnderlineBtnSetup:(UIButton *)btn title:(NSString *)title color:(UIColor *)color hlColor:(UIColor *)hlColor;

+(UISlider *)commonSlider:(UIImage *)maxiumTrackImg;
+(MJRefreshNormalHeader *)commonMJHeaderWithTar:(id)tar action:(SEL)sel;
+(MJRefreshBackNormalFooter *)commonMJFooterWithTar:(id)tar action:(SEL)sel;
+(CAShapeLayer *)dashLayer:(CGFloat)wid;
+(UIView *)dashView:(CGFloat)wid;
+(CAShapeLayer *)dashCompactLayer:(CGFloat)wid;
+(void)showProgAt:(UIView *)view;
+(void)toastAt:(UIView *)view msg:(NSString *)msg color:(UIColor *)textcolor;
+(void)dismissProg;
+(void)commonTransiWith:(UIView *)view blo:(void(^)(void))blo;
+(void)commonTransiWith:(UIView *)view blo:(void(^)(void))blo dura:(CGFloat)dura;
+(void)commonNav:(UIViewController *)vc shadow:(BOOL)shadow line:(BOOL)line translucent:(BOOL)translucent;
+(void)commonNav:(UIViewController *)vc shadow:(BOOL)shadow line:(BOOL)line translucent:(BOOL)translucent color:(UIColor *)bartintcolor;

+(void)commonTexBtn:(UIButton *)btn tar:(id)tar action:(SEL)action shadowOpacity:(CGFloat)opa H:(CGFloat)H;
+(UIInterfaceOrientationMask)orientation2mask:(UIInterfaceOrientation)orientation;
@end
