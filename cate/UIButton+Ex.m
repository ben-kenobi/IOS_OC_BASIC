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

+(instancetype)btnWithImg:(UIImage *)img hlColor:(UIColor *)color{
    UIButton*  btn=[[self alloc]init];
    [btn setImage:img forState:0];
    [btn setImage:[img imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)] forState:UIControlStateHighlighted];
    [[btn imageView] setTintColor:color];
    return btn;
}
+(instancetype)btnWithImg:(UIImage *)img hlImg:(UIImage *)hlimg{
    UIButton *btn = [[self alloc]init];
    [btn setImage:img forState:0];
    [btn setImage:hlimg forState:UIControlStateHighlighted];
    [btn sizeToFit];
    return btn;
}
+(instancetype)btnWithImg:(UIImage *)img selImg:(UIImage *)selimg{
    UIButton *btn = [[self alloc]init];
    [btn setImage:img forState:0];
    [btn setImage:selimg forState:UIControlStateSelected];
    btn.adjustsImageWhenHighlighted=NO;
    [btn sizeToFit];
    return btn;
}
+(instancetype)btnWithImg:(UIImage *)img hlImg:(UIImage *)hlimg selImg:(UIImage *)selimg{
    UIButton *btn = [[self alloc]init];
    [btn setImage:img forState:0];
    [btn setImage:selimg forState:UIControlStateSelected];
    [btn setImage:hlimg forState:UIControlStateHighlighted];
    btn.adjustsImageWhenHighlighted=hlimg;
    [btn sizeToFit];
    return btn;
}

@end
