

#import "YFCate.h"
#import <sys/utsname.h>


void myCleanupBlock(__strong void(^*block)(void)){
    (*block)();
}


UIWindow *frontestWindow(){
#ifdef IOS_MAIN_CONTAINER_FLAG
    if(iVersion>=11){
        UIWindow *window = iApp.windows[0];
        if(CGRectEqualToRect(iScreen.bounds , window.bounds)){
            return window;
        }
        return iApp.windows[1];
    }else{
        UIWindow *window = iApp.windows[iApp.windows.count-1];
        if(CGRectEqualToRect(iScreen.bounds , window.bounds)){
            return window;
        }
        return iApp.windows[iApp.windows.count-2];
    }
#else
    return nil;
#endif
}
UIImage * i18nImg(NSString * name){
    UIImage *img = img(name);
    if(isRightToLeft()){
        return img.horizonMirroredImg;
    }
    return img;
}






@implementation iDialog : NSObject
+(void)dialogWith:(NSString*)title msg:(NSString*)msg actions:(NSArray *)actions vc:(UIViewController*)vc{
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert] ;
    for (UIAlertAction* action in actions){
        [ac addAction:action];
    }
    [vc presentViewController:ac animated:true completion:nil];
}

@end


