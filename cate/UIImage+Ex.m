//
//  UIImage+Ex.m
//Created by apple on 17/07/21.
//

#import "UIImage+Ex.h"
#import <ImageIO/ImageIO.h>
#import "H264VideoParser.h"
#import <AVFoundation/AVFoundation.h>

CGMutablePathRef shapePath(CGRect rect,NSInteger count,NSInteger step,NSInteger multi,CGFloat froma){
    if(!count) return 0;
    
    CGSize size=rect.size;
    CGPoint p=rect.origin;
    CGFloat cx=size.width*.5+p.x,cy=size.height*.5+p.y,
    rad=MIN(size.width,size.height)*.5;
    CGMutablePathRef path=CGPathCreateMutable();
    CGMutablePathRef patharc=CGPathCreateMutable();
    
    CGFloat from=froma,to=from,gap=2*M_PI/count;
    CGPathAddArc(patharc, 0, cx, cy, rad, from, to, 0);
    CGPoint cur=CGPathGetCurrentPoint(patharc);
    CGPathMoveToPoint(path, 0, cur.x, cur.y);
    
    for(int i=1;i<=step;i++){
        
        to=from+gap*multi;
        CGPathAddArc(patharc, 0, cx, cy, rad, from, to, 0);
        cur=CGPathGetCurrentPoint(patharc);
        CGPathAddLineToPoint(path, 0, cur.x, cur.y);
        from=to;
        
        if(!(i*multi%count)){
            to=from+gap;
            CGPathAddArc(patharc, 0, cx, cy, rad, from, to, 0);
            cur=CGPathGetCurrentPoint(patharc);
            CGPathMoveToPoint(path, 0, cur.x, cur.y);
            from=to;
        }
    }
    CGPathRelease(patharc);
    return path;
    
}

@implementation UIImage (Ex)

+(instancetype)shapeImgWithSize:(CGSize)size color:(UIColor *)color count:(NSInteger)count multi:(NSInteger)multi step:(NSInteger)step drawType:(int)type{
    UIGraphicsBeginImageContextWithOptions(size, 0, 0);
    CGContextRef con=UIGraphicsGetCurrentContext();
    CGMutablePathRef path= shapePath((CGRect){0,0,size}, count, step, multi,0);
    CGContextAddPath(con,path);
    CGPathRelease(path);
    [color set];
    CGContextDrawPath(con, type);
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


+ (instancetype)img4Color:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)img4Color:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,iScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (instancetype)roundStretchImg4Color:(UIColor *)color w:(CGFloat)w {
    CGRect rect = CGRectMake(0, 0, w, w);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,iScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddArc(context, w*.5, w*.5, w*0.5, 0, 2 * M_PI, 0);
    CGContextClip(context);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image.resizableStretchImg;
}


+(instancetype)img4CVPixel:(CVPixelBufferRef)buf{
    UIImage *img = [UIImage imageWithCIImage:[CIImage imageWithCVPixelBuffer:buf]];
    CVPixelBufferRelease(buf);
    return img;
}

+(instancetype)imgFromV:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, 0, 0);
    CGContextRef con=UIGraphicsGetCurrentContext();
    [view.layer renderInContext:con];
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


-(instancetype)resizableStretchImg{
    CGFloat  w=self.size.width*.5;
    CGFloat h=self.size.height*.5;
    return [self resizableImageWithCapInsets:(UIEdgeInsets){h,w,h,w} resizingMode:UIImageResizingModeStretch];
}

-(instancetype)alwaysTemplate{
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
-(instancetype)alwaysOrigin{
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

-(instancetype)clipBy:(int)idx count:(int)count scale:(CGFloat)scale{
    CGFloat h=self.size.height*iScreen.scale,
    w=self.size.width/count*iScreen.scale;
    CGImageRef ci=CGImageCreateWithImageInRect([self CGImage], (CGRect){idx*w,0,w,h});
    UIImage *img= [UIImage imageWithCGImage:ci  scale:scale orientation:0];
    CGImageRelease(ci);
    return img;
    
}
-(UIImage *)renderWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, self.w,self.h);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,iScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextSetFillColorWithColor(context,  color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [img verticalMirroredImg];
}
-(UIImage *)verticalMirroredImg{
    return [UIImage imageWithCGImage:self.CGImage scale:iScreen.scale orientation:UIImageOrientationDownMirrored];
}
-(UIImage *)horizonMirroredImg{
     return [UIImage imageWithCGImage:self.CGImage scale:iScreen.scale orientation:UIImageOrientationLeftMirrored];
}
-(UIImage *)scaleImg2size:(CGSize)size{
    
    CGRect tar={0,0,size};
    if(!CGSizeEqualToSize(self.size, size)){
        CGFloat scale=MIN(size.width /self.size.width, size.height/self.size.height);
        tar.size.width=self.size.width*scale;
        tar.size.height=self.size.height*scale;
        tar.origin.x=(size.width-tar.size.width)*.5;
        tar.origin.y=(size.height-tar.size.height)*.5;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, 0, 0);
    [self drawInRect:tar];
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}





+(UIImage *)gifImgF:(NSString *)path{
    return [self gifImg:[NSData dataWithContentsOfFile:path]];
}


+(UIImage *)gifImg:(NSData *)data{
    
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            duration += [self frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
    
}



+ (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

+(instancetype)imgFromH264Data:(NSData *)data{
    if(!data||!data.length)return nil;
    return [self img4CVPixel:[H264VideoParser parseData:data]];
}
+(instancetype)imgFromH264File:(NSString *)path{
    if(![iFm fileExistsAtPath:path isDirectory:0])
        return nil;
    return [self img4CVPixel:[H264VideoParser parseFile:path]];
}









-(CGFloat)h{
    return self.size.height;
}
-(CGFloat)w{
    return self.size.width;
}


-(instancetype)roundImg:(CGFloat)ivW boderColor:(UIColor*)color borderW:(CGFloat)borderW{
    CGFloat w2=MIN(self.h, self.w);
    CGFloat r = ivW == 0 ? w2 : ivW;
    CGFloat scale = r/w2;
    CGFloat rad=r*0.5+borderW;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rad*2, rad*2), false, 0);
    CGContextRef con=UIGraphicsGetCurrentContext();
    if (borderW>0){
        CGContextAddArc(con,rad,rad,rad,0, 2 * M_PI,0);
        [color setFill];
        CGContextDrawPath(con, kCGPathFill);
    }
    
    CGContextAddArc(con, rad, rad, r*0.5, 0, 2 * M_PI, 0);
    CGContextClip(con);
    [self drawInRect:CGRectMake(r-scale*self.w+borderW, r-scale*self.h+borderW, scale*self.w,scale*self.h)];
    
    
    UIImage* img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}



-(instancetype) scale2w:(CGFloat)wid{
    CGSize size = CGSizeMake(wid, wid/self.w*self.h);
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


+(instancetype)launchImg{
    NSDictionary* dict=iBundle.infoDictionary;
    NSArray *images = dict[@"UILaunchImages"] ;
    if(!images||!images.count) return nil;
    CGSize scrsize=iScreen.bounds.size;
    for (NSDictionary *dict in images) {
        CGSize size=CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(size, scrsize)) {
            return img(dict[@"UILaunchImageName"]);
        }
    }
    return nil;
}



+(instancetype)imgFromLayer:(CALayer*)layer{
    UIGraphicsBeginImageContextWithOptions(layer.size, false, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}




-(instancetype)convertAndroidPointNine{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.w-6, self.h-6), false, 0);
    CGContextRef con=UIGraphicsGetCurrentContext();
    CGContextDrawImage(con, CGRectMake(-3, -3, self.size.width, self.size.height), self.CGImage);
    
    UIImage * img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [img resizableStretchImg];
}
+(void)generateVideoImage:(NSURL*)url cb:(void (^)(UIImage *img))cb
{
    AVURLAsset* asset=[AVURLAsset assetWithURL:url];
    AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform=true;
    
    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
    
    AVAssetImageGeneratorCompletionHandler handle = ^(CMTime requestedTime, CGImageRef _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result != AVAssetImageGeneratorSucceeded) {
                [iPop toast:@"couldn't generate thumbnail, error:\(error)"];
                return;
            }
            UIImage* img = [UIImage imageWithCGImage:image];
            cb(img);
        });
    };
    
    
    generator.maximumSize = CGSizeMake(320, 180);
    [generator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:thumbTime]]completionHandler:handle];
}

@end
