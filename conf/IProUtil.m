//
//  iProUtil.m
//  day39-project01
//
//  Created by apple on 15/11/22.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import "IProUtil.h"
#import "MD5.h"
#import "UIView+Toast.h"

@interface IProUtil ()
@property (nonatomic,strong)CLLocationManager *man;
@property (nonatomic,copy)void (^locationcb)(BOOL,NSArray *);
@end


@implementation IProUtil

+(void)commonPrompt:(NSString *)title msg:(NSString *)msg cb:(void(^)())cb{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIView * backView = [vc.view.subviews.lastObject subviews].lastObject;
    backView.layer.cornerRadius = dp2po(12);
    backView.backgroundColor = iColor(0xfc, 0xfc, 0xfc, 1);
    
    
    NSString * message  = msg;
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment=NSTextAlignmentCenter;
    NSMutableAttributedString* messageMutableString  = [[NSMutableAttributedString alloc ] initWithString:message attributes:@{NSFontAttributeName:iFont(18),NSForegroundColorAttributeName:iColor(0x11, 0x11, 0x11, 1),NSParagraphStyleAttributeName:paragraphStyle}];
    [vc setValue:messageMutableString forKey: @"attributedMessage"];
    
    if(cb){
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:iStr(@"Cancel") style:UIAlertActionStyleDefault handler:nil];
        [cancel setValue:iColor(0x66, 0x66, 0x66, 1) forKey:@"titleTextColor"];
        [vc addAction:cancel];
    }
    UIAlertAction* ok = [UIAlertAction actionWithTitle:iStr(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(cb)
            cb();
    }];
    [ok setValue:iGlobalFocusColor forKey:@"titleTextColor"];
    
    [vc addAction:ok];
    
    [UIViewController.curVC presentViewController:vc animated:YES completion:0];
}






+(void)prompt:(NSString *)title tcolor:(UIColor *)tcolor tfont:(UIFont*)tfont msg:(NSString *)msg mcolor:(UIColor *)mcolor mfont:(UIFont *)mfont  cb:(void(^)())cb{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIView * backView = [vc.view.subviews.lastObject subviews].lastObject;
    backView.layer.cornerRadius = dp2po(12);
    backView.backgroundColor = iColor(0xfc, 0xfc, 0xfc, 1);
   
    if(title){
        NSMutableAttributedString* titleMutableString  = [[NSMutableAttributedString alloc ] initWithString:title attributes:@{NSFontAttributeName:tfont,NSForegroundColorAttributeName:tcolor}];
        [vc setValue:titleMutableString forKey: @"attributedTitle"];
    }
    
    NSString * message  = msg;
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 3;
    paragraphStyle.alignment=NSTextAlignmentCenter;
    NSMutableAttributedString* messageMutableString  = [[NSMutableAttributedString alloc ] initWithString:message attributes:@{NSFontAttributeName:mfont,NSForegroundColorAttributeName:mcolor,NSParagraphStyleAttributeName:paragraphStyle}];
    [vc setValue:messageMutableString forKey: @"attributedMessage"];
    UIVisualEffectView *ev = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    ev.alpha=.7;
    if(cb){
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:iStr(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [UIView animateWithDuration:.1 animations:^{
                ev.alpha=0;
            } completion:^(BOOL finished) {
                [ev removeFromSuperview];
            }];
        }];
        [cancel setValue:iColor(0x66, 0x66, 0x66, 1) forKey:@"titleTextColor"];
        [vc addAction:cancel];
    }
   
    UIAlertAction* ok = [UIAlertAction actionWithTitle:iStr(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(cb)
            cb();
        [UIView animateWithDuration:.1 animations:^{
            ev.alpha=0;
        } completion:^(BOOL finished) {
            [ev removeFromSuperview];
        }];
    }];
    [ok setValue:iGlobalFocusColor forKey:@"titleTextColor"];
    [vc addAction:ok];
  
    
    [UIViewController.curVC presentViewController:vc animated:YES completion:nil];
    [UIViewController.curVC.view insertSubview:ev belowSubview:vc.view];
    [ev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
}


+(UILabel *)commonLab:(UIFont *)font color:(UIColor *)color{
    UILabel *lab = [[UILabel alloc]init];
    lab.font=font;
    lab.textColor = color;
    lab.textAlignment=NSTextAlignmentLeft;
    lab.lineBreakMode=NSLineBreakByTruncatingTail;
//    lab.text=@"11-22 18:56:43";
    return lab;
}
+(UILabel *)commonLab:(UIFont *)font color:(UIColor *)color bg:(UIColor *)bg{
    UILabel *lab = [[UILabel alloc]init];
    lab.font=font;
    lab.textColor = color;
    lab.textAlignment=NSTextAlignmentCenter;
    lab.lineBreakMode=NSLineBreakByTruncatingTail;
//    lab.text=@"11-22 18:56:43";
    lab.backgroundColor=bg;
    return lab;
}

+(UIButton *)commonTextBtn:(UIFont *)font color:(UIColor *)color title:(NSString *)title{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:0];
    btn.titleLabel.font=font;
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:iGlobalBG forState:UIControlStateHighlighted];
    return btn;
}




+(NSString *)durationFormat:(NSInteger)sec{
    NSString *str = iFormatStr(@"%02ld:%02ld",(sec/60)%60,sec%60);
    if(sec>=60*60)
        str = iFormatStr(@"%02ld:%@",sec/60/60,str);
    return str;
}


+(NSString *)digestAry:(NSArray *)ary{
    NSMutableString *mstr=[NSMutableString string];
    for(NSString *str in ary){
        [mstr appendString:str];
    }
    return [MD5 MD5Encrypt:mstr];
}
+(NSString *)digestStr:(NSString *)str{
    return [MD5 MD5Encrypt:str];
}
+(instancetype)shareInstance{
    static long l=0;
    static IProUtil *instance;
    dispatch_once(&l, ^{
        instance=[[IProUtil alloc] init];
    });
    return instance;
}
+(UIButton *)btnWith:(CGRect)frame title:(NSString *)title bgc:(UIColor *)bgc font:(UIFont *)font sup:(UIView *)sup{
    UIButton *b=[[UIButton alloc] initWithFrame:frame];
    [b setBackgroundColor:bgc];
    [b setTitleColor:[UIColor whiteColor] forState:0];
    [b setTitleColor:[UIColor lightGrayColor] forState:1];
    b.layer.cornerRadius=3;
    //    self.myorder.layer.masksToBounds=YES;
    [b.layer setShadowOpacity:.3];
    [b.layer setShadowOffset:(CGSize){1 ,1}];
    [b.layer setShadowColor:[[UIColor lightGrayColor]CGColor]];
    [b.layer setShadowRadius:1];
    [sup addSubview:b];
    [b setTitle:title forState:0];
    b.titleLabel.font=font;
    return b;
}
+(UILabel*)labWithColor:(UIColor*)color font:(UIFont *)font sup:(UIView *)sup{
    UILabel *lab = [[UILabel alloc] init];
    lab.font=font;
    lab.textColor=color;
    lab.lineBreakMode=NSLineBreakByTruncatingTail;
    [sup addSubview:lab];
    return lab;
}



+(NSRegularExpression *)usernameRe{
    static NSRegularExpression * re;
    long l=0;
    dispatch_once(&l, ^{
        re=[NSRegularExpression regularExpressionWithPattern: @"(^[_a-zA-Z0-9.%+-]+@([_a-z A-Z 0-9]+\\.)+[a-z A-Z 0-9]{2,6}$)|(^0{0,1}(13[0-9]|15[7-9]|153|156|18[0-9])[0-9]{8}$)" options:0 error:0];
    });
        
    return re;
}
+(NSRegularExpression *)mobileRe{
    static NSRegularExpression * re;
    long l=0;
    dispatch_once(&l, ^{
        re=[NSRegularExpression regularExpressionWithPattern: @"(^0{0,1}(13[0-9]|15[7-9]|153|156|18[0-9])[0-9]{8}$)" options:0 error:0];
    });
    
    return re;
}

+(NSRegularExpression *)pwdRe{
    static NSRegularExpression * re;
    long l=0;
    dispatch_once(&l, ^{
        re=[NSRegularExpression regularExpressionWithPattern:@"^[a-z A-Z  0-9]{6,12}$" options:0 error:0];
    });
    return re;
}



#pragma  mark - 
#pragma  mark  CLLocationManagerDelegate
+(void)locationWith:(void (^)(BOOL, NSArray *))cb{
    IProUtil *inst=[self shareInstance];
    inst.locationcb=cb;
    [inst.man startUpdatingLocation];
}

-(CLLocationManager *)man{
    if(!_man){
        _man=[[CLLocationManager alloc] init];
        [_man requestAlwaysAuthorization];
        [_man requestWhenInUseAuthorization];
        _man.delegate=self;
    }
    return _man;
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    [_man stopUpdatingLocation];
    if(self.locationcb){
        self.locationcb(1,locations);
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [_man stopUpdatingLocation];
    if(self.locationcb){
        self.locationcb(0,@[error]);
    }

}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status==kCLAuthorizationStatusDenied){
        [_man stopUpdatingLocation];
    }else{
        [_man startUpdatingLocation];
        
    }
}


+(void)initialize{
    if(self==[IProUtil class]){
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.messageColor = [UIColor whiteColor];
        style.backgroundColor=iColor(0, 0, 0, .8);
        style.messageFont=iFont(14);
        style.cornerRadius=4;
        style.messageAlignment=NSTextAlignmentCenter;
        style.titleAlignment=NSTextAlignmentCenter;
        style.horizontalPadding=60;
        style.verticalPadding=15;
        
        [CSToastManager setSharedStyle:style];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
        [CSToastManager setDefaultPosition:CSToastPositionCenter];
        CSToastManager.defaultDuration=2;
    }
}




@end




CGFloat dp2po(CGFloat dp){
    return iAppDele.sw*dp/375;
}
