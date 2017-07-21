//
//  UIImage+Ex.h
//Created by apple on 17/07/21.
//

#import <UIKit/UIKit.h>

CGMutablePathRef shapePath(CGRect rect,NSInteger count,NSInteger step,NSInteger multi,CGFloat from);
@interface UIImage (Ex)
+(instancetype)shapeImgWithSize:(CGSize)size color:(UIColor *)color count:(NSInteger)count multi:(NSInteger)multi step:(NSInteger)step drawType:(int)type;
-(instancetype)resizableStretchImg;
-(instancetype)clipBy:(int)idx count:(int)count scale:(CGFloat)scale;

+(instancetype)imgFromV:(UIView *)view;
-(UIImage *)scaleImg2size:(CGSize)size;

+(UIImage *)gifImg:(NSData *)data;
+(UIImage *)gifImgF:(NSString *)path;
+ (instancetype)img4Color:(UIColor *)color ;
+(instancetype)img4CVPixel:(CVPixelBufferRef)buf;
+(instancetype)imgFromH264Data:(NSData *)data;
+(instancetype)imgFromH264File:(NSString *)path;

@end
