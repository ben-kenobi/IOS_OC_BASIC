//
//  NSDate+Ex.h
//Created by apple on 17/07/21.
//

#import <Foundation/Foundation.h>

@interface NSDate (Ex)

-(NSString *)dateFormat;
-(NSString *)timeFormat;
-(NSString *)timeFormat2;
-(NSString *)timeMilliFormat;
+(instancetype)dateFromStr:(NSString *)str;
+(instancetype)timeFromStr:(NSString *)str;
+(instancetype)timeMilliFromStr:(NSString *)str;
+(NSInteger)curTimeMilli;
@end
