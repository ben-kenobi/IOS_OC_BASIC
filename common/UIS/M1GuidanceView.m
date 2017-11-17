//
//  M1GuidanceView.m
//  M1Remoter
//
//  Created by yf on 2017/10/24.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import "M1GuidanceView.h"
@interface M1GuidanceView()
@property (nonatomic,strong)UIButton *btn;
@end

@implementation M1GuidanceView

-(instancetype)init{
    if(self = [super init]){
        [self initUI];
    }
    return self;
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self dismiss];
//}


+(void)showAt:(UIView *)view{
     M1GuidanceView *v=[[M1GuidanceView alloc]init];
    [view addSubview:v];
    [v updateAsynchronously:YES completion:^{
        v.frame = view.bounds;
    }];
    v.alpha=0;
    [UIView animateWithDuration:.25 animations:^{
        v.alpha=1;
    }];
}

-(void)dismiss{
    [UIView animateWithDuration:.25 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [iPref(0) setBool:YES forKey:NEW_FUN_GUIDANCED];
}

#pragma mark - UI
-(void)initUI{
    self.dynamic = NO;
    self.tintColor = [UIColor blackColor];
    self.contentMode = UIViewContentModeBottom;
    self.blurRadius=4;
    
    self.btn=[UIButton btnWithImg:img(@"ok_btn") hlImg:[img(@"ok_btn") renderWithColor:iColor(0xaa, 0xaa, 0xaa, 1)]];
    [self.btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@(dp2po(-30)));
    }];
    
    UIImageView *iv=[[UIImageView alloc]initWithImage:img(@"guide_control")];
    [self addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(dp2po(-10)));
        make.top.equalTo(@20);
    }];
}

@end
