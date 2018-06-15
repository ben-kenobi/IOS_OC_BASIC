//
//  NSObject+Ex.m
//Created by apple on 17/07/21.
//

#import "NSObject+Ex.h"
#import "IUtil.h"
@implementation NSObject (Ex)


+(instancetype)setDict:(NSDictionary *)dict{
    return [IUtil setValues:dict forClz:self];
}
+(instancetype)setterDict:(NSDictionary *)dict{
    return [IUtil setterValues:dict forClz:self];
}
-(void)setDict:(NSDictionary *)dict{
    [IUtil setValues:dict forObj:self];
}

-(NSDictionary *)dict{
    return [self dictionaryWithValuesForKeys:[IUtil prosWithClz:self.class]];
}

@end
