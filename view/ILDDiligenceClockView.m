//
//  ILDDiligenceClockView.m
//  ILDiligence
//
//  Created by XueFeng Chen on 2017/3/25.
//  Copyright © 2017年 XueFeng Chen. All rights reserved.
//

#import "ILDDiligenceClockView.h"

#define RADIUS 80
#define POINT_RADIUS 8
#define CIRCLE_WIDTH 4
#define PROGRESS_WIDTH 6
#define TEXT_NAME_SIZE 48
#define TEXT_DATE_SIZE 16
#define TIMER_INTERVAL 3 //0.05  //1秒请求一次获取暴击值；

@interface ILDDiligenceClockView ()

@property(nonatomic, assign) BOOL isRunning;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) CGFloat timeLeft;
@property(nonatomic, assign) CGFloat startAngle;
@property(nonatomic, assign) CGFloat endAngle;

@property(nonatomic, assign) NSInteger diligenceSeconds; //总的暴击值，默认400
@end

@implementation ILDDiligenceClockView

- (id)init {
    if (self = [super init]) {
        [self initData];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initData {
    
    self.startAngle = M_PI/3;
    self.endAngle = self.startAngle;
    self.diligenceSeconds = 400;
    self.timeLeft = 400;
    self.isRunning = NO;
}

- (void)drawRect:(CGRect)rect {
    // calculate angle for progress
    if (self.diligenceSeconds == 0) {
        self.endAngle = self.startAngle;
    } else {
        self.endAngle = (1 - self.timeLeft / self.diligenceSeconds) *(-(2*M_PI-M_PI*5/3)) + self.startAngle*(self.timeLeft / self.diligenceSeconds);
    }
    
    CGFloat radius = (rect.size.width - 20)/2;
    
    // draw circle
    UIBezierPath *circle = [UIBezierPath bezierPath];
    [circle addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                      radius:radius
                  startAngle:-(2*M_PI-M_PI*5/3)
                    endAngle:M_PI/3
                   clockwise:YES];
    circle.lineWidth = CIRCLE_WIDTH;
    circle.lineCapStyle = kCGLineCapRound; //线条拐角
    circle.lineJoinStyle = kCGLineCapRound; //终点处理
    [[UIColor blackColor] setStroke];
    [circle stroke];
    
    // draw progress
    UIBezierPath *progress = [UIBezierPath bezierPath];
    [progress addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                        radius:radius
                    startAngle:self.endAngle
                      endAngle:self.startAngle
                     clockwise:YES];
    progress.lineWidth = CIRCLE_WIDTH;
    [[UIColor colorWithHexString:@"#f97b00"] setStroke];
    progress.lineCapStyle = kCGLineCapRound; //线条拐角
    progress.lineJoinStyle = kCGLineCapRound; //终点处理
    [progress stroke];
    
    NSInteger leave = self.diligenceSeconds - self.timeLeft;
    if (self.isRunning && leave > 0 && leave<400) {
         NSString * textContent =  [NSString stringWithFormat:@"%.0lf",self.diligenceSeconds - self.timeLeft];
        UIFont *textFont = [UIFont fontWithName: @"-" size: TEXT_NAME_SIZE];
        CGSize textSize = [textContent sizeWithAttributes:@{NSFontAttributeName:textFont}];
        CGRect textRect = CGRectMake(rect.size.width - 50 ,
                                     rect.size.height - textSize.height*2,
                                     textSize.width , textSize.height);
        
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = NSTextAlignmentCenter;
        
        [textContent drawInRect:textRect withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:textStyle}];
        
    }
        // if Timer is running, always show time left in the center of the circle
        NSString *textContent = [NSString stringWithFormat:@"暴走值"];
        UIFont *textFont = [UIFont fontWithName: @"-" size: TEXT_NAME_SIZE];
        CGSize textSize = [textContent sizeWithAttributes:@{NSFontAttributeName:textFont}];
        CGRect textRect = CGRectMake(rect.size.width/2 + 30  ,
                                     rect.size.height - textSize.height,
                                     textSize.width , textSize.height); //- textSize.width
        
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = NSTextAlignmentCenter;
        
        [textContent drawInRect:textRect withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:textStyle}];
}

- (void)startTimer {
    if (!self.isRunning) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        //开始倒计时；
        self.isRunning = YES;
    }
}

- (void)pauseTimer {
    if (self.isRunning) {
        [self.timer setFireDate:[NSDate distantFuture]];
        //暂停倒计时；
        self.isRunning = NO;
    }
}

- (void)resumeTimer {
    if (!self.isRunning) {
        [self.timer setFireDate:[NSDate distantPast]];
        //开始倒计时
        self.isRunning = YES;
    }
}

- (void)stopTimer {
    [self.timer invalidate];
//    self.timer = nil; //by qiugaoying
    self.startAngle = M_PI/3;
    self.endAngle = self.startAngle;
    self.timeLeft = 0; //self.diligenceSeconds; 暴走值满了后不消失
    self.isRunning = NO;
    [self setNeedsDisplay];
}

//请求网络，设置暴击值；
- (void)updateProgress {
    
    if(self.requestCritValueBlock){
        self.requestCritValueBlock();
    }
    
    if (self.timeLeft > 0) {
//        self.timeLeft -= TIMER_INTERVAL;
       
//        [self setNeedsDisplay];
    } else {
//        [self stopTimer]; // 停止请求暴击值？
        
        if (self.delegate) {
            [self.delegate taskCompleted];
        }
    }
}

- (void)setIsRestMode:(BOOL)isRestMode {
    _isRestMode = isRestMode;
    if(isRestMode){
        self.timeLeft = self.diligenceSeconds;
    }
    [self setNeedsDisplay];
}

- (void)setDiligenceSeconds:(NSInteger)diligenceSeconds {
    _diligenceSeconds = diligenceSeconds;
    _timeLeft = diligenceSeconds;
}


-(void)fill_LeftCritValue:(NSInteger)critValue
{
    self.timeLeft = self.diligenceSeconds - critValue;
    [self setNeedsDisplay];  //系统触发调用drawRect
}
@end
