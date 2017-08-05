

#import "UIView+Ex.h"
#import "UIColor+Ex.h"
#import "UIImage+Ex.h"
#import "NSString+Ex.h"
#import "NSArray+Ex.h"
#import "IUtil.h"
#import "UIViewController+Ex.h"
#import "Masonry.h"
#import "NSDate+Ex.h"
#import "NSObject+Ex.h"
#import "FileUtil.h"
#import "NetUtil.h"
#import "UIImageView+WEB.h"
#import "UIButton+Ex.h"


BOOL emptyStr(NSString *str);

NSTimer * iTimer(CGFloat inteval,id tar,SEL sel,id userinfo);

CADisplayLink *iDLink(id tar,SEL sel);
void runOnMain(void (^blo)());
NSString * iphoneType() ;
