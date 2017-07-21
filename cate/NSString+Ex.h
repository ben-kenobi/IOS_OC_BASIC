//
//  NSString+Ex.h
//Created by apple on 17/07/21.
//

#import <Foundation/Foundation.h>

@interface NSString (Ex)

-(instancetype)strByAppendToCachePath;
-(instancetype)strByAppendToDocPath;
-(instancetype)strByAppendToTempPath;
-(BOOL)ignorecaseEqualTo:(NSString *) str;
-(unsigned int)toHexValue;
-(UInt8)toHexByte;
@end
