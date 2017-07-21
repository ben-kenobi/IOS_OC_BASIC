//
//  NSDate+Ex.m
//Created by apple on 17/07/21.
//

#import "NSDate+Ex.h"

@implementation NSDate (Ex)


-(NSString *)dateFormat{
    static  NSDateFormatter *fm;
    if(!fm){
        fm=[[NSDateFormatter alloc] init];
        fm.dateFormat=@"yyyy-MM-dd";
    }
    return [fm stringFromDate:self];
    
}
-(NSString *)timeFormat{
    static  NSDateFormatter *fm;
    if(!fm){
        fm=[[NSDateFormatter alloc] init];
        fm.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    }
    return [fm stringFromDate:self];
}
-(NSString *)timeMilliFormat{
    static  NSDateFormatter *fm;
    if(!fm){
        fm=[[NSDateFormatter alloc] init];
        fm.dateFormat=@"yyyy-MM-dd HH:mm:ss.SSS";
    }
    return [fm stringFromDate:self];
}

-(NSString *)timeFormat2{
    static  NSDateFormatter *fm;
    if(!fm){
        fm=[[NSDateFormatter alloc] init];
        fm.dateFormat=@"yyyy-MM-dd HH:mm";
    }
    return [fm stringFromDate:self];
}

+(instancetype)dateFromStr:(NSString *)str{
    static  NSDateFormatter *fm;
    if(!fm){
        fm=[[NSDateFormatter alloc] init];
        fm.dateFormat=@"yyyy-MM-dd";
    }
    return [fm dateFromString:str];
}
+(instancetype)timeFromStr:(NSString *)str{
    static  NSDateFormatter *fm;
    if(!fm){
        fm=[[NSDateFormatter alloc] init];
        fm.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    }
    return [fm dateFromString:str];
}


+(instancetype)timeMilliFromStr:(NSString *)str{
    static  NSDateFormatter *fm;
    if(!fm){
        fm=[[NSDateFormatter alloc] init];
        fm.dateFormat=@"yyyy-MM-dd HH:mm:ss.SSS";
    }
    return [fm dateFromString:str];
}

+(NSInteger)curTimeMilli{
    return [[NSDate date] timeIntervalSince1970]*1000;
}


@end
