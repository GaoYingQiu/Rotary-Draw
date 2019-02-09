//
//  ILDDiligenceClockView.m
//  ILDiligence
//
//  Created by XueFeng Chen on 2017/3/25.
//  Copyright © 2017年 XueFeng Chen. All rights reserved.
//

#import "DiligenceClockView.h"

#define RADIUS 80
#define POINT_RADIUS 8
#define CIRCLE_WIDTH 4
#define PROGRESS_WIDTH 6
#define TEXT_NAME_SIZE 48
#define TEXT_DATE_SIZE 16
#define TIMER_INTERVAL 0.05

@interface DiligenceClockView ()

@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) CGFloat timeLeft;
@property(nonatomic, assign) CGFloat startAngle;
@property(nonatomic, assign) CGFloat endAngle;
@end

@implementation DiligenceClockView

- (id)init {
    if (self = [super init]) {
        [self initData];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initData {
    self.startAngle = M_PI*4/3;
    self.endAngle = self.startAngle;
    self.diligenceSeconds = 0;
    self.timeLeft = 0;
    self.isRunning = NO;
}

- (void)drawRect:(CGRect)rect {
    // calculate angle for progress
    if (self.diligenceSeconds == 0) {
        self.endAngle = self.startAngle;
    } else {
        self.endAngle = (1 - self.timeLeft / self.diligenceSeconds) *(M_PI*2/3)  + self.startAngle*(self.timeLeft / self.diligenceSeconds);
    }
    
    CGFloat radius = (rect.size.width - 20)/2;
    
    // draw circle
    UIBezierPath *circle = [UIBezierPath bezierPath];
    [circle addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                      radius:radius
                  startAngle:M_PI*4/3
                    endAngle:M_PI*2/3
                   clockwise:NO];
    circle.lineWidth = CIRCLE_WIDTH;
    circle.lineCapStyle = kCGLineCapRound; //线条拐角
    circle.lineJoinStyle = kCGLineCapRound; //终点处理
    
    if(self.timeLeft == self.diligenceSeconds){
        //定时器走完，底色变成黑色；
        [[UIColor blackColor] setStroke];
    }else{
        [[UIColor colorWithHexString:@"#506fff"] setStroke];
    }
    [circle stroke];
    
    // draw progress
    UIBezierPath *progress = [UIBezierPath bezierPath];
    [progress addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                        radius:radius
                    startAngle:self.endAngle
                      endAngle:self.startAngle
                     clockwise:YES];
    progress.lineWidth = CIRCLE_WIDTH;
    [[UIColor blackColor] setStroke];
    progress.lineCapStyle = kCGLineCapRound; //线条拐角
    progress.lineJoinStyle = kCGLineCapRound; //终点处理
    [progress stroke];
    
    if (self.isRunning) {
        // if Timer is running, always show time left in the center of the circle
      
        NSString * textContent =  [NSString stringWithFormat:@"%.0lfs",self.timeLeft];
        UIFont *textFont = [UIFont fontWithName: @"-" size: TEXT_NAME_SIZE];
        CGSize textSize = [textContent sizeWithAttributes:@{NSFontAttributeName:textFont}];
        CGRect textRect = CGRectMake(50 ,
                                     rect.size.height - textSize.height*2,
                                     textSize.width , textSize.height);
        
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = NSTextAlignmentCenter;
        
        [textContent drawInRect:textRect withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:textStyle}];
    }
    NSString *textContent = [NSString stringWithFormat:@"倒计时"];
    
    UIFont *textFont = [UIFont fontWithName: @"-" size: TEXT_NAME_SIZE];
    CGSize textSize = [textContent sizeWithAttributes:@{NSFontAttributeName:textFont}];
    CGRect textRect = CGRectMake(rect.size.width/2 - textSize.width - 30,
                                 rect.size.height - textSize.height,
                                 textSize.width , textSize.height);
    
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
    self.startAngle = M_PI*4/3;
    self.endAngle = self.startAngle;
    self.timeLeft = self.diligenceSeconds;
    self.isRunning = NO;
    [self setNeedsDisplay];
}

- (void)updateProgress {
    if (self.timeLeft > 0) {
        self.timeLeft -= TIMER_INTERVAL;
        [self setNeedsDisplay];
    } else {
        [self stopTimer];
        
        if (self.delegate) {
            [self.delegate taskClockCompleted];
        }
    }
}

- (void)setIsRestMode:(BOOL)isRestMode {
    _isRestMode = isRestMode;
    [self setNeedsDisplay];
}

- (void)setDiligenceSeconds:(NSInteger)diligenceSeconds {
    _diligenceSeconds = diligenceSeconds;
    _timeLeft = diligenceSeconds;
}

-(void)fill_LeftTimeValue:(NSInteger)timeValue
{
    //设置剩余时间；
    _timeLeft = timeValue;
    [self setNeedsDisplay];
}
@end
