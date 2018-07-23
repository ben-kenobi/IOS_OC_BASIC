

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import "SVProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIView+Toast.h"



void myCleanupBlock(__strong void(^*block)(void)){
    (*block)();
}


UIWindow *frontestWindow(){
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
}
UIImage * i18nImg(NSString * name){
    UIImage *img = img(name);
    if(isRightToLeft()){
        return img.horizonMirroredImg;
    }
    return img;
}





@implementation iPop
+(void)showMsg:(NSString*)msg{
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD showInfoWithStatus:msg];
}
+(void)showSuc:(NSString*)msg{
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD showSuccessWithStatus:msg];
}
+(void)showError:(NSString*)msg{
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD showErrorWithStatus:msg];
}
+(void)showProgWithMsg:(NSString *)msg{
    [SVProgressHUD setBackgroundLayerColor:iColor(0, 0, 0, .6)];
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeCustom)];
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [SVProgressHUD  showWithStatus:msg];
}
+(void)showProg{
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD  show];
}
+(void)dismProg{
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
    [SVProgressHUD dismiss];
}
+(void)toastWarn:(NSString*)msg{
    if(!msg)return;
    [UIUtil toastAt:[UIViewController curVC].view msg:msg color:iWarnTipColor];

//    runOnMain(^{
//        //        iApp.windows[iApp.windows.count-1].makeToast(msg)
//       /* [frontestWindow() makeToast:msg duration:1.5 position:nil title:nil image:nil style:[CSToastManager sharedStyle] completion:nil];*/
//    });
}
+(void)toastSuc:(NSString *)msg{
    if(!msg)return;
     [UIUtil toastAt:[UIViewController curVC].view msg:msg color:iSucTipColor];
}
+(void)toastInfo:(NSString *)msg{
    if(!msg)return;
     [UIUtil toastAt:[UIViewController curVC].view msg:msg color:iInfoTipColor];
}

+(void)bannerWarn:(NSString*)msg{
    if(!msg)return;
    [UIUtil showAt:[UIViewController curVC].view msg:msg color:iWarnTipColor];
}
+(void)bannerSuc:(NSString *)msg{
    if(!msg)return;
    [UIUtil showAt:[UIViewController curVC].view msg:msg color:iSucTipColor];
}
+(void)bannerInfo:(NSString *)msg{
    if(!msg)return;
    [UIUtil showAt:[UIViewController curVC].view msg:msg color:iInfoTipColor];
}
@end


@implementation iDialog : NSObject
+(void)dialogWith:(NSString*)title msg:(NSString*)msg actions:(NSArray *)actions vc:(UIViewController*)vc{
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert] ;
    for (UIAlertAction* action in actions){
        [ac addAction:action];
    }
    [vc presentViewController:ac animated:true completion:nil];
}

@end

@implementation ALUtil:NSObject
+(void)setImgFromALURL:(NSURL*)alurl cb:(void(^)(UIImage *))cb{
    ALAssetsLibraryAssetForURLResultBlock resultblock=^(ALAsset *asset){
        ALAssetRepresentation* rep = asset.defaultRepresentation;
        __unsafe_unretained CGImageRef iref =  [rep fullResolutionImage];
        UIImage * image = [UIImage imageWithCGImage:iref];
        dispatch_async(dispatch_get_main_queue(), ^{
            cb(image);
        });
    };
    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *error){
        printf("\n-----load ALAssets fail------\n");
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:alurl resultBlock:resultblock failureBlock:failureblock];
}
@end

