
//
//  YFMsgBanner.m
//  BatteryCam
//
//  Created by yf on 2018/2/28.
//  Copyright © 2018年 oceanwing. All rights reserved.
//

#import "YFMsgBanner.h"


@interface YFMsgBanner()

@property (nonatomic,strong)UILabel *msgLab;
@property (nonatomic,assign)NSInteger countdown;
@property (nonatomic,strong)NSString *iden;
@end

@implementation YFMsgBanner

+(instancetype)showAt:(UIView*)view withCountdown:(NSInteger)sec msg:(NSString *)msg iden:(NSString *)iden color:(UIColor *)textcolor{
    if(!view) return nil;
    YFMsgBanner *banner = [msgBanners() objectForKey:iden];
    if(!banner)
        banner = [[YFMsgBanner alloc]init];
    banner.countdown=sec;
    banner.msgLab.text=msg;
    if(textcolor)
        banner.msgLab.textColor=textcolor;
    banner.iden=iden;
    [banner showAt:view];
    return banner;
}

#pragma markk - show

-(void)showAt:(UIView *)view{
    [IProUtil dispatchCancel:self];
    if(self.superview!=view){
        [self removeFromSuperview];
        self.alpha=0;
        [view addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).offset(view.layoutMargins.top);
            make.leading.trailing.equalTo(@0);
        }];
        [self.msgLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@15);
            make.trailing.equalTo(@(-10));
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@0);
        }];
        
        [view layoutIfNeeded];
    }
    [msgBanners() setObject:self forKey:self.iden];

    [self.msgLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-10));
        make.top.equalTo(@12);
        make.bottom.equalTo(@-12);
    }];
    
    [UIUtil commonAnimation:^{
        [view layoutIfNeeded];
        self.alpha=1;
    }];
    @weakRef(self)
    [IProUtil dispatchAfter:self.countdown tar:self bloc:^{
        [weak_self dismiss];
    }];
}



#pragma markk - dismiss
+(void)dismiss:(NSString *)iden{
    YFMsgBanner *banner = [msgBanners() objectForKey:iden];
    [banner dismiss];
}

-(void)removeFromSuperview{
    [super removeFromSuperview];
    [IProUtil dispatchCancel:self];
    [msgBanners() removeObjectForKey:self.iden];
}

-(void)dismiss{
    [IProUtil dispatchCancel:self];
    if(!self.superview)return;
    [self.msgLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-10));
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@0);
    }];
    @weakRef(self)
    [UIUtil commonAnimationWithDuration:.25 cb:^{
        [weak_self.superview layoutIfNeeded];
        weak_self.alpha=0;
    } comp:^(BOOL finish) {
        [weak_self removeFromSuperview];
    }];
}



#pragma mark - UI
-(instancetype)init{
    if(self = [super init]){
        [self initUI];
    }
    return self;
}
-(void)initUI{
    self.clipsToBounds=NO;
    self.backgroundColor=iColor(0xff, 0xf9, 0xd8, 1);
    
    self.msgLab=[IProUtil commonLab:iFont(14) color:iColor(0xff, 0x73, 0x0a, 1)];
    self.msgLab.numberOfLines=0;
    self.msgLab.textAlignment=NSTextAlignmentCenter;

    
    [UIUtil commonShadow:self opacity:.06];
    
    // layout ------
    [self addSubview:self.msgLab];

}




           
           
NSMutableDictionary * msgBanners(){
    static NSMutableDictionary *mdict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mdict=[NSMutableDictionary dictionary];
    });
    return mdict;
}
@end
