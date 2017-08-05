//
//  UIButton+Ex.m
//  BatteryCam
//
//  Created by yf on 2017/8/5.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import "UIButton+Ex.h"

@implementation UIButton(Ex)

+(instancetype)btnWithImg:(UIImage *)img diableColor:(UIColor *)color{
    UIButton*  btn=[[self alloc]init];
    [btn setImage:img forState:0];
    [btn setImage:[img imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)] forState:UIControlStateDisabled];
    [[btn imageView] setTintColor:color];
    return btn;
}

@end
