//
//  UIViewController+Ex.m
//Created by apple on 17/07/21.
//

#import "UIViewController+Ex.h"
#import "objc/runtime.h"
#import "YFCate.h"


@implementation UIViewController (Ex)

+(void)pushVC:(UIViewController *)vc{
//   id obj= [objc_getAssociatedObject(iApp, iVCKey) navigationController];
#ifdef IOS_MAIN_CONTAINER_FLAG

    runOnMain(^{
        UIViewController * obj=self.curVC;
        [obj showViewController:vc sender:nil];
        //        if([obj  isKindOfClass:[UINavigationController class]]){
        ////            [(UINavigationController *)obj pushViewController:vc animated:YES];
        //            [(UINavigationController *)obj showViewController:vc sender:0];
        //        }else{
        //            [[obj navigationController] showViewController:vc sender:nil];
        ////            [[obj navigationController] pushViewController:vc animated:YES];
        //        }

    });
#else
#endif
}

+(void)setVC:(UIViewController *)vc{
#ifdef IOS_MAIN_CONTAINER_FLAG
    objc_setAssociatedObject(iApp, iVCKey, vc, OBJC_ASSOCIATION_ASSIGN);
#endif
}

+(void)popVC{
#ifdef IOS_MAIN_CONTAINER_FLAG
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *obj=objc_getAssociatedObject(iApp, iVCKey);
        if([obj  isKindOfClass:[UINavigationController class]]){
            [(UINavigationController *)obj popViewControllerAnimated:YES];
        }else{
            [ [obj navigationController] popViewControllerAnimated:YES];
        }
    });
#else
#endif
}

+(instancetype)curVC{
#ifdef IOS_MAIN_CONTAINER_FLAG

   return  objc_getAssociatedObject(iApp, iVCKey);
#else
    return nil;
#endif
}

-(void)alert:(NSString *)title msg:(NSString *)msg{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [vc addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:0]];
    [self presentViewController:vc animated:YES completion:nil];
}


+(UIViewController *)topVC{
#ifdef IOS_MAIN_CONTAINER_FLAG

    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
#else
    return nil;
#endif
}
@end
