//
//  AVUtil.m
//Created by apple on 17/07/21.
//

#import "AVUtil.h"

static NSMutableDictionary *_sounddict;

@implementation AVUtil


+(void)initialize{
    _sounddict = [[NSMutableDictionary alloc] init];
}


+(void)playAlertAudio:(NSURL  *)url{
    SystemSoundID soundid = [_sounddict[url.absoluteString] intValue];
    if(!soundid){
        // unsupport audio longer than 30 secs
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)url, &soundid);
        _sounddict[url.absoluteString]=@(soundid);
    }
    
    // with shake effect
    AudioServicesPlayAlertSoundWithCompletion(soundid,nil);
    
}
+(void)playSystemAudio:(NSURL  *)url{
    SystemSoundID soundid = [_sounddict[url.absoluteString] intValue];
    if(!soundid){
        // unsupport audio longer than 30 secs
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)url, &soundid);
        _sounddict[url.absoluteString]=@(soundid);
    }
    AudioServicesPlaySystemSoundWithCompletion(soundid, nil);
}
+(void)playAlertAudioOnce:(NSURL  *)url{
    SystemSoundID soundid = 0;
    // unsupport audio longer than 30 secs
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)url, &soundid);
    
    // with shake effect
    AudioServicesPlayAlertSoundWithCompletion(soundid, ^{
        AudioServicesDisposeSystemSoundID(soundid);
        
    });
    
}
+(void)playSystemAudioOnce:(NSURL  *)url{
    SystemSoundID soundid = 0;
    // unsupport audio longer than 30 secs
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)url, &soundid);
    
    AudioServicesPlaySystemSoundWithCompletion(soundid,^{
        AudioServicesDisposeSystemSoundID(soundid);
        
    });
    
}




+(void)disposeAudios{
    for ( id sounid in [_sounddict allValues]){
        AudioServicesDisposeSystemSoundID([sounid intValue]);
    }
    
    [_sounddict removeAllObjects];
}
@end
