//
//  VideoParser.h
//  Created by yf on 2017/6/30.
//  Copyright © 2017年 yf. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VideoPacket : NSObject

@property uint8_t* buffer;
@property NSInteger size;

@end

@interface H264VideoParser : NSObject

+(void)parseFile:(NSString *)path cb:(void(^)(CVPixelBufferRef))decodeCB;
+(CVPixelBufferRef)parseData:(NSData *)data ;
+(CVPixelBufferRef)parseFile:(NSString *)path ;

@end
