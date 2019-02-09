//
//  UserPrizeInfoCyclePlayView.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/9.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "UserPrizeInfoCyclePlayView.h"
@interface UserPrizeInfoCyclePlayView()
@property(nonatomic,strong) CADisplayLink *link;
@property(nonatomic,strong) NSMutableArray *imageArray;
@property(nonatomic,strong) NSMutableArray *deleteImageArray;

@end


@implementation UserPrizeInfoCyclePlayView

//画板的长 = 头像的长 + 昵称的长 + 内容的长 + 表情的长 * 表情个数 + 间距。然后就是分别绘制背景图片，用户昵称，内容和表情，最后返回一张图片。

//由于上面设置超出圆形的部分要裁剪，那即将要绘制背景岂不是要被裁剪，所以在绘制圆形区域上一句执行了CGContextSaveGState(ctx)表示复制了一份画板（上下文）存到栈里，在绘制背景图片之前执行CGContextRestoreGState(ctx)，表示用之前保存的画板替换当前的，因为之前保存的画板没有设置超出圆形区域要裁剪的需求，当然替换当前的画板，会把当前画板上的绘图也copy过去。
#pragma mark - 绘制弹幕图片
- (GYImage *)imageWithBarrage:(NSString *)danMuStr{
    // 开启绘图上下文
    //
    UIFont *font = LJFontRegularText(10);
   
//    CGFloat iconH = 20;
//    CGFloat iconW = iconH;
    // 间距
    CGFloat marginX = 10;
    
    // 表情的尺寸
//    CGFloat emotionW = 25;
//    CGFloat emotionH = emotionW;
    // 计算用户名占据的区域
//    CGSize nameSize = [danMu.userName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    // 计算内容占据的区域
    CGSize textSize = [danMuStr sizeWithFont:font constrainedToWidth:MAXFLOAT];  //[danMuStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    // 位图上下文的尺寸
    CGFloat contentH = 22;
    CGFloat contentW = textSize.width + 53;
    
//    CGFloat contentW = iconW + 4 * marginX + nameSize.width + textSize.width + danMu.emotions.count * emotionH;
    
    CGSize contextSize = CGSizeMake(contentW, contentH);
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, 0.0);
    
    // 获得位图上下文
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 将上下文保存到栈中
//    CGContextSaveGState(ctx);
//    // 1.绘制圆形区域
//    CGRect iconFrame = CGRectMake(0, 0, iconW, iconH);
//    // 绘制头像圆形
//    CGContextAddEllipseInRect(ctx, iconFrame);
//    // 超出圆形的要裁剪
//    CGContextClip(ctx);
    // 2.绘制头像
//    UIImage *icon = danMu.type ? [UIImage imageNamed:@"headImage_1"]:[UIImage imageNamed:@"headImage_2"];
//    [icon drawInRect:iconFrame];
    // 将上下文出栈替换当前上下文
//    CGContextRestoreGState(ctx);
    // 3.绘制背景图片
//    CGFloat bgX =  marginX/2;
    CGFloat bgX = 0;
    CGFloat bgY = 0;
    CGFloat bgW = contentW;
    CGFloat bgH = contentH;
    [[UIColor colorWithWhite:0 alpha:0.4] set];
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(bgX, bgY, bgW, bgH) cornerRadius:10] fill];
    
    // 4.绘制用户名
//    CGFloat nameX = bgX + marginX;
//    CGFloat nameY = (contentH - nameSize.height) * 0.5;
//    [danMu.userName drawAtPoint:CGPointMake(nameX, nameY) withAttributes:@{NSAttachmentAttributeName:font,NSForegroundColorAttributeName:danMu.type == NO ? [UIColor orangeColor]:[UIColor blackColor]}];
    
    // 5.绘制内容
    CGFloat textX =   marginX ; //(contentW - textSize.width) * 0.5;
    CGFloat textY = (contentH - textSize.height) * 0.5;
//    CGFloat textX = nameX + nameSize.width + marginX;
//    CGFloat textY = nameY;
    [danMuStr drawAtPoint:CGPointMake(textX, textY) withAttributes:@{NSAttachmentAttributeName:font,NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.6]}];
    
    // 6.绘制表情
//    __block CGFloat emotionX = textX + textSize.width;
//    CGFloat emotionY = (contentH - emotionH) * 0.5;
//    [danMu.emotions enumerateObjectsUsingBlock:^(NSString *emotionName, NSUInteger idx, BOOL * _Nonnull stop) {
//        // 加载表情图片
//        UIImage *emotion = [UIImage imageNamed:emotionName];
//        [emotion drawInRect:CGRectMake(emotionX, emotionY, emotionW, emotionH)];
//        // 修改emotionX
//        emotionX += emotionW;
//    }];
    
    // 从位图上下文中获得绘制好的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return [[GYImage alloc] initWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}

//开启绘图定时器，回调方法是setNeedsDisplay，这样就会执行- (void)drawRect:(CGRect)rect每次修改image.x(由于UIImage没有x、y属性，所以写了个类拓展BAImage)，滚动不在屏幕范围内的会销毁
#pragma mark - 添加定时器
- (void)addTimer{
    if (self.link) {
        return;
    }
    // 每秒执行60次回调
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    // 将定时器添加到runLoop
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.link = link;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
#pragma mark - 绘制移动
- (void)drawRect:(CGRect)rect{
    
    for (GYImage *image in self.imageArray) {
        image.x -= 1.5;
        // 绘制图片
        [image drawAtPoint:CGPointMake(image.x, image.y)];
        // 判断图片是否超出屏幕
        if (image.x + image.size.width < 0) {
            [self.deleteImageArray addObject:image];
        }
    }
    // 移除超过屏幕的弹幕
    for (GYImage *image in self.deleteImageArray) {
        [self.imageArray removeObject:image];
    }
    [self.deleteImageArray removeAllObjects];
}


-(void)addImage:(GYImage *)image
{
    [self.imageArray addObject:image];
}

-(NSMutableArray *)imageArray{
    if(_imageArray == nil){
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}

-(NSMutableArray *)deleteImageArray{
    if(_deleteImageArray == nil){
        _deleteImageArray = [[NSMutableArray alloc]init];
    }
    return _deleteImageArray;
}


@end
