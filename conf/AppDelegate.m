//
//  AppDelegate.m
//Created by apple on 17/07/21.

//
#import "AppDelegate.h"
#import "BaseCommon.h"

#define FIELD_CNT       4

@interface AppDelegate ()

@end

@implementation AppDelegate
-(void)dealloc{
    [iNotiCenter removeObserver:self];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window=[[UIWindow alloc] initWithFrame:iScreen.bounds];
    [self setNavRoot:iRes4ary(@"mainvcs.plist")[0]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    [application setStatusBarHidden:YES];
    
    
//    [[UINavigationBar appearance] setTintColor:iColor(21,188, 173, 1)];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:iColor(21,188, 173, 1)}];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateDisabled];
//    [iNotiCenter addObserver:self selector:@selector(setRootVC) name:GUIDENOTI object:0];
   

    
    [self setNavigationBarStyle];
    
    return YES;
}
-(void)setNavRoot:(NSDictionary *)dict{
    UIViewController *vc= [NSClassFromString(dict[@"clz"]).alloc init];
    UINavigationController *nav=nil;
    nav=[NSClassFromString(dict[@"nav"]).alloc initWithRootViewController:vc];
    vc.title=dict[@"title"];
    self.window.rootViewController=nav;
}
- (void)setNavigationBarStyle
{
    //设置状态栏的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //
    UINavigationBar *bar = [UINavigationBar appearance];
    //设置显示的颜色
    bar.barTintColor = [UIColor colorWithRed:39/255.0 green:38/255.0 blue:54/255.0 alpha:1.0];
    //设置字体颜色
    bar.tintColor = [UIColor whiteColor];
    bar.translucent=NO;
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}
//
// get Device Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    NSLog(@"Registration successful, bundle identifier: %@, device token: %@",
          [NSBundle.mainBundle bundleIdentifier], deviceToken);
    
    
}
// Get Device Token Fail
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    NSLog(@"%@",str);
}
//
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber += 1;
    
    NSLog(@"didReceiveRemoteNotification:%@", userInfo);
    
}













//-----------------------former---------------

//invoke by external app
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    NSLog(@"callback----%@",url);
//    BOOL result = [UMSocialSnsService handleOpenURL:url];
//    if (result == FALSE) {
//        
//    }
//    return result;
    return nil;
}



-(void)setRootVC{
    self.window.rootViewController=[AppDelegate vc];
}

+(UIViewController *)vc{
    NSString *ver=[iPref(0) objectForKey:@"appVersion"];
    NSString *curver=[iBundle infoDictionary][@"CFBundleShortVersionString"];
    if([ver isEqualToString:curver]){
        return [self rootVC:YES];
    }else{
        [iPref(0) setObject:curver forKey:@"appVersion"];
        [iPref(0) synchronize];
        return [[NSClassFromString(iRes4dict(@"conf.plist")[@"introVC"]) alloc] init];
    }
}
+(UIViewController *)rootVC:(BOOL)lock{
    if( [iPref(@"settingPref") boolForKey:@"lockScreen"]&&lock){
        return [[NSClassFromString(iRes4dict(@"conf.plist")[@"lockVC"]) alloc] init];
    }else{
        return  [[NSClassFromString(iRes4dict(@"conf.plist")[@"rootVC"]) alloc] init];
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   UIBackgroundTaskIdentifier taskID=[application beginBackgroundTaskWithExpirationHandler:^{
       
   }];
    if(taskID != UIBackgroundTaskInvalid){
        [iApp endBackgroundTask:taskID];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    
}




@end
