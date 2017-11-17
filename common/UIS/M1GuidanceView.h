//
//  M1GuidanceView.h
//  M1Remoter
//
//  Created by yf on 2017/10/24.
//  Copyright © 2017年 oceanwing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"
@interface M1GuidanceView : FXBlurView
+(void)showAt:(UIView *)view;
-(void)dismiss;
@end
