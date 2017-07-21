//
//  NSObject+Ex.m
//Created by apple on 17/07/21.
//

#import "NSObject+Ex.h"

@implementation NSObject (Ex)


+(instancetype)setDict:(NSDictionary *)dict{
    return [IUtil setValues:dict forClz:self];
}

-(NSDictionary *)dict{
    return [self dictionaryWithValuesForKeys:[IUtil prosWithClz:self.class]];
}

@end
