//
//  ILDDiligenceClockView.h
//  ILDiligence
//
//  Created by qiugaoying Chen on 2019/1/05.
//

#import <UIKit/UIKit.h>
typedef void(^TimesToRequestCritValueBlock)(void);

@protocol ILDDiligenceClockViewDelegate
- (void)taskCompleted;
@end

//暴击值；
@interface ILDDiligenceClockView : UIView

@property(nonatomic, strong) NSString *taskName;
@property(nonatomic, assign) BOOL isRestMode;
@property (nonatomic, weak) id<ILDDiligenceClockViewDelegate> delegate;
@property(nonatomic,copy) TimesToRequestCritValueBlock requestCritValueBlock; //请求暴击值；

- (void)startTimer;
- (void)pauseTimer;
- (void)resumeTimer;
- (void)stopTimer;

-(void)fill_LeftCritValue:(NSInteger)critValue; //设置暴击值；
@end
