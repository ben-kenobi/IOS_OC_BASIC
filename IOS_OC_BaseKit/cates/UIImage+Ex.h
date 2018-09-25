//
//  UIImage+Ex.h
//Created by apple on 17/07/21.
//

#import <UIKit/UIKit.h>

CGMutablePathRef shapePath(CGRect rect,NSInteger count,NSInteger step,NSInteger multi,CGFloat from);
@interface UIImage (Ex)
+(instancetype)shapeImgWithSize:(CGSize)size color:(UIColor *)color count:(NSInteger)count multi:(NSInteger)multi step:(NSInteger)step drawType:(int)type;
-(instancetype)resizableStretchImg;
-(instancetype)alwaysTemplate;
-(instancetype)alwaysOrigin;
-(instancetype)clipBy:(int)idx count:(int)count scale:(CGFloat)scale;

+(instancetype)imgFromV:(UIView *)view;
+(instancetype)imgFromLayer:(CALayer*)layer;
//将图片截取成方形，按比例计算xy起始点
-(instancetype)squareBy:(CGFloat)ratio;
- (UIImage *)fixOrientation ;
-(void)imgToCVPixel:(CVPixelBufferRef *)bufp;
-(CVPixelBufferRef) pixelBufferRef;
-(UIImage *)scaleImg2size:(CGSize)size;
-(UIImage *)rotate4Angle:(CGFloat)angle;
-(UIImage *)rotate4Angle2:(CGFloat)angle;

-(instancetype)roundImg:(CGFloat)ivW boderColor:(UIColor*)color borderW:(CGFloat)borderW;
-(UIImage *)renderWithColor:(UIColor *)color;
-(UIImage *)verticalMirroredImg;
-(UIImage *)horizonMirroredImg;

+(UIImage *)gifImg:(NSData *)data;
+(UIImage *)gifImgF:(NSString *)path;
+ (instancetype)img4Color:(UIColor *)color ;
+ (instancetype)img4Color:(UIColor *)color size:(CGSize)size ;
+ (instancetype)roundStretchImg4Color:(UIColor *)color w:(CGFloat)w ;
+ (instancetype)roundStretchImg4Color:(UIColor *)color w:(CGFloat)w withBorder:(UIColor *)boderColor;
+(instancetype)img4CVPixel:(CVPixelBufferRef)buf;


-(CGFloat)h;
-(CGFloat)w;


-(instancetype) scale2w:(CGFloat)wid;
-(instancetype)scale2PreciseW:(CGFloat)wid;
+(instancetype)launchImg;
-(instancetype)convertAndroidPointNine;
+(void)generateVideoImage:(NSURL*)url cb:(void (^)(UIImage *img))cb;
@end


@interface CIImage (Ex)
-(CGFloat)h;
-(CGFloat)w;
@end
