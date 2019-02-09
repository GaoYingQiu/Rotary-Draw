//
//  ILDDiligenceClockView.h
//  ILDiligence
//
//  Created by XueFeng Chen on 2017/3/25.
//  Copyright © 2017年 XueFeng Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiligenceClockViewDelegate

- (void)taskClockCompleted;

@end
//倒计时；
@interface DiligenceClockView : UIView
@property(nonatomic, assign) NSInteger diligenceSeconds;
@property(nonatomic, strong) NSString *taskName;
@property(nonatomic, assign) BOOL isRestMode;
@property(nonatomic, assign) BOOL isRunning;

@property (nonatomic, weak) id<DiligenceClockViewDelegate> delegate;

- (void)startTimer;
- (void)pauseTimer;
- (void)resumeTimer;
- (void)stopTimer;

-(void)fill_LeftTimeValue:(NSInteger)timeValue; //设置倒计时；
@end
