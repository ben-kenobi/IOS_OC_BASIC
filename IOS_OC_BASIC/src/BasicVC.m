//
//  BasicVC.m
//  IOS_OC_BASIC
//
//  Created by yf on 2018/7/23.
//  Copyright © 2018年 yf. All rights reserved.
//

#import "BasicVC.h"

@interface BasicVC ()
@property (nonatomic,strong)UIImageView *iv1;
@property (nonatomic,strong)UIImageView *iv2;
@property (nonatomic,strong)UIImageView *iv3;
@property (nonatomic,strong)UIImageView *iv4;

@property (nonatomic, assign) CVPixelBufferPoolRef pixelBufferPool;

@end

@implementation BasicVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self testLocale];
}

-(void)testLocale{
    NSLocale *loc = [NSLocale currentLocale];
    NSLog(@"%@\n\n\n%@\n\n\n%@\n\n\n",localeLanguage(),localeCountry(),[NSLocale preferredLanguages]);
}

-(void)testBMBuf{
    
    [self initUI];
    
    UIImage *img = img(@"voice_con");
    self.iv1.image=img;
    int width , height;
    unsigned char * buf = [img convertToBMRGBA8:&width oHeight:&height];
   UIImage *img2 = [UIImage imgFromBMBuf:buf withWidth:width withHeight:height];
    self.iv2.image = img2;
    free(buf);
}
-(void)testCVPixel{
    
    [self initUI];

    UIImage *img = imgFromF(iRes(@"edit_blue_icon.png"));
    self.iv1.image=img;
    CVPixelBufferRef bufref = nil;
    [img imgToCVPixel:&bufref];
    
    
    
    UIImage *img2=[UIImage img4CVPixel:bufref];
    self.iv2.image=img2;
    CVPixelBufferRef bufref2 = [img pixelBufferRef];
    UIImage *img3=[UIImage img4CVPixel:bufref2];
    self.iv3.image=img3;
    //    //    self.iv4.image=img;
    //    [iPop bannerWarn:NSLocalizedString(@"The face angle is incorrect. Please retake the face with front view angle.", 0)];
    //     [UIUtil alwaysShowMsgAt:self.view msg:NSLocalizedString(@"The face angle is incorrect. Please retake the face with front view angle.", 0) color:iGlobalErrorColor icon:0 iden:NSStringFromClass(self.class)];
}


#pragma mark - UI
-(void)initUI{
    self.iv1 = [[UIImageView alloc]init];
    self.iv2 = [[UIImageView alloc]init];
    self.iv3 = [[UIImageView alloc]init];
    self.iv4 = [[UIImageView alloc]init];

    [self.view addSubview:self.iv1];
    [self.view addSubview:self.iv2];
    [self.view addSubview:self.iv3];
    [self.view addSubview:self.iv4];
    [self.iv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
    [self.iv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iv2.mas_top).offset(-10);
        make.centerX.equalTo(@0);
    }];
    [self.iv3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iv2.mas_bottom).offset(10);
        make.centerX.equalTo(@0);
    }];
    [self.iv4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iv3.mas_bottom).offset(10);
        make.centerX.equalTo(@0);
    }];
}



@end
