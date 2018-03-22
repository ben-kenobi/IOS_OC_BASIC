//
//  UIUtil.m
//  BatteryCam
//
//  Created by yf on 2017/9/13.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import "UIUtil.h"
#import "MJRefresh.h"
#import "BCProgressV.h"
#import "YFMsgBanner.h"

@implementation UIUtil
+(void)commonShadow:(UIView *)view opacity:(CGFloat)opacity{
    [self commonShadowWithRadius:8 view:view opacity:opacity];
}

+(void)commonShadowWithRadius:(NSInteger)rad view:(UIView *)view opacity:(CGFloat)opacity{
    [self commonShadowWithRadius:rad size:CGSizeMake(0, 2) view:view opacity:opacity];
}
+(void)commonShadowWithRadius:(NSInteger)rad size:(CGSize)size view:(UIView *)view opacity:(CGFloat)opacity{
    [self commonShadowWithColor:[UIColor blackColor] Radius:rad size:size view:view opacity:opacity];
}
+(void)commonAnimation:(void (^)(void))cb{
    [self commonAnimationWithDuration:.25 cb:cb];
}
+(void)commonAnimationWithDuration:(CGFloat)dura cb:(void (^)(void))cb{
    [self commonAnimationWithDuration:dura cb:cb comp:nil];

}
+(void)commonAnimationWithDuration:(CGFloat)dura cb:(void (^)(void))cb comp:(void (^)(BOOL finish))comp{
    [UIView animateWithDuration:dura delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:cb completion:comp];
}

+(void)commonShadowWithColor:(UIColor*)color Radius:(NSInteger)rad size:(CGSize)size view:(UIView *)view opacity:(CGFloat)opacity{
    view.layer.shadowColor=color.CGColor;
    view.layer.shadowOffset=size;
    view.layer.shadowRadius=rad;
    view.layer.shadowOpacity=opacity;
}

+(UISlider *)commonSlider:(UIImage *)maxiumTrackImg{
    UISlider *slider=[[BCSlider alloc]init];
    [slider setContinuous:YES];
    [slider setMaximumTrackImage:(maxiumTrackImg?maxiumTrackImg:img(@"progress_bar"))  forState:0];
    slider.tintColor=iGlobalFocusColor;
    [slider setThumbImage:img(@"slider_controls") forState:0];
    return slider;
}

+(void)commonUnderlineBtnSetup:(UIButton *)btn{
    [self commonUnderlineBtnSetup:btn title:[btn titleForState:0] color:[btn titleColorForState:0] hlColor:iGlobalFocusColor];
}

+(void)commonUnderlineBtnSetup:(UIButton *)btn title:(NSString *)title{
    [self commonUnderlineBtnSetup:btn title:title color:iColor(0xaa, 0xaa, 0xaa, 1) hlColor:iGlobalFocusColor];
}

+(void)commonUnderlineBtnSetup:(UIButton *)btn title:(NSString *)title color:(UIColor *)color hlColor:(UIColor *)hlColor{
    
    [btn setAttributedTitle:[[NSAttributedString alloc]initWithString:title attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:iFont(dp2po(14)),NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:color
                                                                                         }] forState:0];
    [btn setAttributedTitle:[[NSAttributedString alloc]initWithString:title attributes:@{NSForegroundColorAttributeName:hlColor,NSFontAttributeName:iFont(dp2po(14)),NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:hlColor
                                                                                         }] forState:UIControlStateHighlighted];
    btn.contentEdgeInsets=UIEdgeInsetsMake(5, 5, 5, 5);
}

+(MJRefreshNormalHeader *)commonMJHeaderWithTar:(id)tar action:(SEL)sel{
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:tar refreshingAction:sel];
    
    header.stateLabel.font = iFont(14);
    header.lastUpdatedTimeLabel.font = iFont(12);
    header.stateLabel.textColor = [UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    return header;
}
+(MJRefreshBackNormalFooter *)commonMJFooterWithTar:(id)tar action:(SEL)sel{
    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:tar refreshingAction:sel];
    footer.stateLabel.textColor=[UIColor grayColor];
    footer.stateLabel.font=iFont(14);
    return footer;
}

+(CAShapeLayer *)dashLayer:(CGFloat)wid{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:CGRectMake(0, 0, wid, 1)];
    [shapeLayer setPosition:CGPointMake(wid*.5, .5)];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[iColor(0xbb, 0xbb, 0xbb, 1) CGColor]];
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinMiter];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:5],
      [NSNumber numberWithInt:5],nil]];
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,0, .5);
    CGPathAddLineToPoint(path, NULL, wid, .5);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    return shapeLayer;
}

+(CAShapeLayer *)dashCompactLayer:(CGFloat)wid{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:CGRectMake(0, 0, wid, 1)];
    [shapeLayer setPosition:CGPointMake(wid*.5, .5)];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[iColor(0xe2, 0xe2, 0xe2, 1) CGColor]];
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinMiter];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:4],
      [NSNumber numberWithInt:2],nil]];
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,0, .5);
    CGPathAddLineToPoint(path, NULL, wid, .5);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    return shapeLayer;
}

+(UIView *)dashView:(CGFloat)wid{
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, wid, 1)];
    [v.layer addSublayer:[self dashLayer:wid]];
    return v;
}


+(void)showProgAt:(UIView *)view{
    [BCProgressV showAt:view];
}
+(void)dismissProg{
    [BCProgressV dismiss];
}

+(void)toastAt:(UIView *)view msg:(NSString *)msg color:(UIColor *)textColor{
    [YFMsgBanner showAt:view withCountdown:4 msg:msg iden:@"msg" color:textColor];
}


+(void)commonTransiWith:(UIView *)view blo:(void(^)(void))blo dura:(CGFloat)dura{
    blo();

    [UIView transitionWithView:view duration:dura options:(UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionShowHideTransitionViews|UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut) animations:^{
        blo();
    } completion:nil];
}

+(void)commonTransiWith:(UIView *)view blo:(void(^)(void))blo{
    [self commonTransiWith:view blo:blo dura:.25];
}

+(void)commonNav:(UIViewController *)vc shadow:(BOOL)shadow line:(BOOL)line translucent:(BOOL)translucent{
    [self commonNav:vc shadow:shadow line:line translucent:translucent color:[UIColor whiteColor]];
}

+(void)commonNav:(UIViewController *)vc shadow:(BOOL)shadow line:(BOOL)line translucent:(BOOL)translucent color:(UIColor *)bartintcolor{
    UINavigationBar *bar = vc.navigationController.navigationBar;
    [self commonShadow:bar opacity:shadow?.08:0];
    bar.shadowImage=line?[UIImage img4Color:iColor(0xe6, 0xe6, 0xe6, 1)]:[UIImage new];
    bar.translucent=translucent;
    [bar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    bar.barTintColor=[UIColor whiteColor];
    bar.barTintColor=bartintcolor;
}

+(void)commonTexBtn:(UIButton *)btn tar:(id)tar action:(SEL)action shadowOpacity:(CGFloat)opa H:(CGFloat)H{
    [btn setBackgroundImage:[UIImage roundStretchImg4Color:iGlobalFocusColor w:H] forState:0];
    [btn setBackgroundImage:[UIImage roundStretchImg4Color:iGlobalHLFocusColor w:H] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage roundStretchImg4Color:[iGlobalFocusColor colorWithAlphaComponent:.3] w:H] forState:UIControlStateDisabled];
    [UIUtil commonShadowWithColor:iColor(0x46, 0x9c, 0xf2, 1) Radius:12 size:CGSizeMake(0, 4) view:btn opacity:opa];
    [btn addTarget:tar action:action forControlEvents:UIControlEventTouchUpInside];
}
+(UIInterfaceOrientationMask)orientation2mask:(UIInterfaceOrientation)orientation{
    if(orientation==UIInterfaceOrientationPortraitUpsideDown){
        return UIInterfaceOrientationMaskPortraitUpsideDown;
    }else if(orientation==UIInterfaceOrientationLandscapeLeft){
        return UIInterfaceOrientationMaskLandscapeLeft;
    }else if(orientation==UIInterfaceOrientationLandscapeRight){
        return UIInterfaceOrientationMaskLandscapeRight;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}
@end



@implementation BCSlider
-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    CGSize size =  self.currentThumbImage.size;
    return CGRectMake(size.width/-2+value*rect.size.width, self.icy-size.height/2+3, size.width, size.height);
}
@end
