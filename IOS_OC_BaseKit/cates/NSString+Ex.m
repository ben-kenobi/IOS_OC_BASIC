//
//  NSString+Ex.m
//Created by apple on 17/07/21.
//

#import "NSString+Ex.h"
#import <UIKit/UIKit.h>
#import "IUtil.h"

@implementation NSString (Ex)


-(instancetype)strByAppendToCachePath{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:self.lastPathComponent];
}



-(instancetype)strByAppendToDocPath{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:self.lastPathComponent];
}
-(instancetype)strByAppendToTempPath{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:self.lastPathComponent];
}

-(BOOL)ignorecaseEqualTo:(NSString *)str{
    return [self.lowercaseString isEqualToString:str.lowercaseString];
}
-(unsigned int)toHexValue{
    unsigned int val;
    [[NSScanner scannerWithString:[self substringWithRange:(NSRange){0,self.length}] ] scanHexInt:&val];
    return val;
}
-(int64_t)toHexLongValue{
    unsigned long long val;
    [[NSScanner scannerWithString:[self substringWithRange:(NSRange){0,self.length}] ] scanHexLongLong:&val];
    return (int64_t)val;
}
-(UInt8)toHexByte{
    return (UInt8)[self toHexValue];
}
-(CGSize)sizeBy:(UIFont *)font{
    return [self boundingRectWithSize:(CGSize){CGFLOAT_MAX,CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}
-(CGSize)sizeBy:(CGSize)size font:(UIFont *)font{
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

-(NSAttributedString *)h5Str{
    if(emptyStr(self))return nil;
    NSAttributedString *astr = [[NSAttributedString alloc]initWithData:[self dataUsingEncoding:4] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:@(4)} documentAttributes:nil error:0];
    return astr;
}

@end
