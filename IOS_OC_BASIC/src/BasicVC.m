//
//  BasicVC.m
//  IOS_OC_BASIC
//
//  Created by yf on 2018/7/23.
//  Copyright © 2018年 yf. All rights reserved.
//

#import "BasicVC.h"

@interface BasicVC ()

@end

@implementation BasicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}



#pragma mark - UI
-(void)initUI{
    UIButton *normalBtn = [IProUtil commonTextBtn:iFont(18) color:[UIColor whiteColor] title:@"FNJJJJF"];
    UIButton *strokeBtn = [IProUtil commonTextBtn:iFont(18) color:[UIColor blackColor] title:@"KKKKFf"];
    UIButton *disBtn = [IProUtil commonTextBtn:iFont(18) color:[UIColor whiteColor] title:@"FFEEEF"];
    [UIUtil commonTexBtn:normalBtn tar:0 action:0 shadowOpacity:0 H:0];
    [UIUtil commonStrokeBtn:strokeBtn tar:0 action:0 shadowOpacity:.1 H:10];
    [UIUtil commonTexBtn:disBtn tar:0 action:0 shadowOpacity:0 H:0];
    [self.view addSubview:normalBtn];
    [self.view addSubview:strokeBtn];
    [self.view addSubview:disBtn];
    disBtn.enabled=NO;
    [normalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(iScreenW-40));
        make.height.equalTo(@50);
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
    }];
    [strokeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerX.equalTo(normalBtn);
        make.top.equalTo(normalBtn.mas_bottom).offset(20);
    }];
    [disBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerX.equalTo(normalBtn);
        make.top.equalTo(strokeBtn.mas_bottom).offset(20);
    }];
}



@end
