//
//  iProUtil.m
//  day39-project01
//
//  Created by apple on 15/11/22.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import "IProUtil.h"
#import "MyMD5.h"
#import "UIView+Toast.h"
#import "M1GuidanceView.h"
#import "BCUIAlertVC.h"
#import "SVProgressHUD.h"
#import "objc/runtime.h"

@interface BCDisableNoShadowBtn:UIButton
@end

@interface IProUtil ()
@property (nonatomic,strong)CLLocationManager *man;
@property (nonatomic,copy)void (^locationcb)(BOOL,NSArray *);
@end


@implementation IProUtil

+(void)commonPrompt:(NSString *)title msg:(NSString *)msg cb:(void(^)(void))cb{
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




+(UIAlertController *)commonTextFieldDialog:(NSString*)title msg:(NSString *)msg ph:(NSString *)ph text:(NSString *)text cb:(void (^)(BOOL isOK,NSString *text))cb{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: title
                                                                              message: msg    preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(dp2po(30)));
        }];
        textField.font=iFont(dp2po(17));
        textField.borderStyle=UITextBorderStyleNone;
        textField.placeholder = ph;
        textField.tintColor=iGlobalFocusColor;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.text=text;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        cb(NO,nil);
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        NSString* name = namefield.text;
        cb(YES,name);
    }]];
    return alertController;
}

+(void)prompt:(NSString *)title tcolor:(UIColor *)tcolor tfont:(UIFont*)tfont msg:(NSString *)msg mcolor:(UIColor *)mcolor mfont:(UIFont *)mfont  cb:(void(^)(void))cb{
    [self prompt:title tcolor:tcolor tfont:tfont msg:msg mcolor:mcolor mfont:mfont vc:UIViewController.curVC cb:cb];
}




+(void)prompt:(NSString *)title tcolor:(UIColor *)tcolor tfont:(UIFont*)tfont msg:(NSString *)msg mcolor:(UIColor *)mcolor mfont:(UIFont *)mfont vc:(UIViewController *)fromVC cb:(void(^)(void))cb{
    BCUIAlertVC *vc = [BCUIAlertVC alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    UIView * backView = [vc.view.subviews.lastObject subviews].lastObject;
//    backView.layer.cornerRadius = dp2po(12);
//    backView.backgroundColor = iColor(0xfc, 0xfc, 0xfc, 1);
    
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
    
    
    M1GuidanceView *ev=[[M1GuidanceView alloc]init];
    
    vc.dismissCB = ^{
        [ev dismiss];
    };
    if(cb){
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:iStr(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [cancel setValue:iColor(0x66, 0x66, 0x66, 1) forKey:@"titleTextColor"];
        [vc addAction:cancel];
    }
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:iStr(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(cb)
            cb();
    }];
    [ok setValue:iGlobalFocusColor forKey:@"titleTextColor"];
    [vc addAction:ok];
    
    
    [fromVC presentViewController:vc animated:YES completion:nil];
    [ev showBy:^UIView *(M1GuidanceView *v) {
        UIViewController *avc = fromVC.navigationController?fromVC.navigationController:fromVC;
        [avc.view insertSubview:ev belowSubview:vc.view];
        return avc.view;
    }];

}
+(void)prompt:(NSAttributedString *)msg cb:(void(^)(void))cb{
    BCUIAlertVC *vc = [BCUIAlertVC alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [vc setValue:msg forKey: @"attributedMessage"];
    
    
    M1GuidanceView *ev=[[M1GuidanceView alloc]init];
    
    vc.dismissCB = ^{
        [ev dismiss];
    };
    if(cb){
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:iStr(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [cancel setValue:iColor(0x66, 0x66, 0x66, 1) forKey:@"titleTextColor"];
        [vc addAction:cancel];
    }
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:iStr(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(cb)
            cb();
    }];
    [ok setValue:iGlobalFocusColor forKey:@"titleTextColor"];
    [vc addAction:ok];
    
    UIViewController *fromVC = UIViewController.curVC;
    
    [fromVC presentViewController:vc animated:YES completion:nil];
    [ev showBy:^UIView *(M1GuidanceView *v) {
        UIViewController *avc = fromVC.navigationController?fromVC.navigationController:fromVC;
        [avc.view insertSubview:ev belowSubview:vc.view];
        return avc.view;
    }];
}



+(void)sheetPrompt:(id<BCStyleSheetListDelegate>)datas vc:(UIViewController *)fromVC{
    BCAlertStylesheetVC *ac = [[BCAlertStylesheetVC alloc]init];
    ac.datas=datas;
    [fromVC presentViewController:ac animated:NO completion:nil];
    M1GuidanceView *ev=[[M1GuidanceView alloc]init];
    ac.dismissCB = ^{
        [ev dismiss];
    };
    [ev showBy:^UIView *(M1GuidanceView *v) {
        UIViewController *avc = fromVC.navigationController?fromVC.navigationController:fromVC;
        [avc.view insertSubview:ev belowSubview:ac.view];
        return avc.view;
    }];
}

+(void)present:(BCBasePromtpVC *)vc from:(UIViewController *)fromVC{
    [fromVC presentViewController:vc animated:NO completion:nil];
    M1GuidanceView *ev=[[M1GuidanceView alloc]init];
    vc.dismissCB = ^{
        [ev dismiss];
    };
    [ev showBy:^UIView *(M1GuidanceView *v) {
        UIViewController *avc = fromVC.navigationController?fromVC.navigationController:fromVC;
        [avc.view insertSubview:ev belowSubview:vc.view];
        return avc.view;
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
    UIButton *btn = [[BCDisableNoShadowBtn alloc] init];
    [btn setTitle:title forState:0];
    btn.titleLabel.font=font;
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:[color colorWithAlphaComponent:.6] forState:UIControlStateHighlighted];
    return btn;
}
+(UIButton *)commonNoShadowTextBtn:(UIFont *)font color:(UIColor *)color title:(NSString *)title{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:0];
    btn.titleLabel.font=font;
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:[color colorWithAlphaComponent:.6] forState:UIControlStateHighlighted];
    [btn setTitleColor:[color colorWithAlphaComponent:.3] forState:UIControlStateDisabled];
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
    return [MyMD5 MD5Encrypt:mstr];
}
+(NSString *)digestStr:(NSString *)str{
    return [MyMD5 MD5Encrypt:str];
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
        //toast
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
        
        
        //svprogresshud
        [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
//        UIImageView *iv = self.commonLoadingSubIv;
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage img4Color:iColor(0xff, 0x00,0,0) size:CGSizeMake(dp2po(42), dp2po(42))]];
        UIActivityIndicatorView *actindi = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        [iv addSubview:actindi];
        [actindi startAnimating];
        [actindi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
        }];
        [SVProgressHUD setLoadingImageView:iv];
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeCustom];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    }
}

+(BOOL)isEmail:(NSString *)str{
    if(emptyStr(str))return NO;
    static NSString * emailRegex = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$";
    static NSPredicate *pred=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    });
    return [pred evaluateWithObject:str];
}

+(BOOL)isLoginPwd:(NSString*)str{
//    if(!str||str.length<8||str.length>20) return NO;
//    return YES;
    static NSPredicate *pred=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * pwdRegex = @"^.+$";
        pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pwdRegex];
    });
    return [pred evaluateWithObject:str];
}
+(BOOL)isSignupPwd:(NSString*)str{
    if(!str||str.length<8||str.length>20) return NO;
    return YES;
    /*
    static NSPredicate *pred=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *REGEX_PASSWORD_LENGTH = @"^.{8,20}$";
        
        NSString *REGEX_PASSWORD_NUM = @"^.*[0-9]+.*$";
        
        NSString *REGEX_PASSWORD_UPPER_LETTER = @"^.*[A-Z]+.*$";
        
        NSString *REGEX_PASSWORD_LOWER_LETTER = @"^.*[a-z]+.*$";
        
//        NSString *REGEX_PASSWORD_SPE_CHARACTERS = @"^.*[~'!@#￥$%^&*()-+_=:/{/}/[/]/./?]+.*$";
        
        pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@  AND SELF MATCHES %@ AND SELF MATCHES %@ AND SELF MATCHES %@ AND SELF MATCHES %@",REGEX_PASSWORD_LENGTH,REGEX_PASSWORD_NUM,REGEX_PASSWORD_UPPER_LETTER,REGEX_PASSWORD_LOWER_LETTER];
    });
    return [pred evaluateWithObject:str];
     */
}
+(BOOL)isSignupNickname:(NSString*)str{
    if(!str||str.length<=0||str.length>64) return NO;
    return YES;
}


+(NSString *)getDeviceId{
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}



+(NSDictionary *)attrDictWith:(UIColor *)fcolor font:(UIFont *)font{
    return @{NSForegroundColorAttributeName:fcolor,NSFontAttributeName:font};
}


+(UIImageView *)commonLoadingIv{
    UIImageView *bgiv = [[UIImageView alloc]initWithImage:img(@"loading_security_bg")];
    UIImageView *iv = [self commonLoadingSubIv];
    [bgiv addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
    return bgiv;
}

+(UIImageView *)commonLoadingSubIv{
    NSMutableArray *mary = [[NSMutableArray alloc]init];
    for(int i=0;i<30;i++){
        NSData *data=iData4F(iRes(iFormatStr(@"/Photos/loading/loading_%02d.png",i)));
        [mary addObject:[[UIImage alloc]initWithData:data scale:2]];
    }
    UIImageView *iv = [[UIImageView alloc]init];
    iv.animationImages=mary;
    iv.animationDuration=.04*mary.count;
    iv.animationRepeatCount=0;
    [iv startAnimating];
    return iv;
}

+(void)dispatchAfter:(CGFloat)secs tar:(id)tar bloc:(void(^)(void))bloc{
    if(secs<0)return;
    [self dispatchCancel:tar];
    __weak id wt = tar;
    dispatch_block_t block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
        objc_setAssociatedObject(wt, "tblockkey", nil, OBJC_ASSOCIATION_ASSIGN);
        bloc();
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(secs * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
    objc_setAssociatedObject(tar, "tblockkey", block, OBJC_ASSOCIATION_ASSIGN);
}
+(void)dispatchCancel:(id)tar{
    dispatch_block_t block = objc_getAssociatedObject(tar, "tblockkey");
    if(block){
        dispatch_block_cancel(block);
        objc_setAssociatedObject(tar, "tblockkey", nil, OBJC_ASSOCIATION_ASSIGN);
    };
}
@end

@implementation BCDisableNoShadowBtn
-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    self.layer.shadowOpacity=enabled?.12:0;
}
@end


CGFloat dp2po(CGFloat dp){
    return iAppDele.sw*dp/375;
}
