//
//  AVUtil.h
//Created by apple on 17/07/21.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface YFAVUtil : NSObject

+(void)playAlertAudio:(NSURL  *)url;
+(void)playSystemAudio:(NSURL  *)url;
+(void)playAlertAudioOnce:(NSURL  *)url;//播发音频，不缓存
+(void)playSystemAudioOnce:(NSURL  *)url;//播发音频，不缓存

@end
