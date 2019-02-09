//
//  TYRotaryView.h
//  TYRotaryDemo
//
//  Created by Qiugaoying on 2018/5/14.
//  Copyright © 2018年 hxq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Rotary_Level_Happly, //欢乐
    Rotary_Level_Crit, //黄金
    Rotary_Level_Gold, //暴击模式
} Rotary_Level;

@interface TYRotaryView : UIView

@property (nonatomic, strong) UIButton *startButton;

//动画旋转 至 index的位置
-(void)animationWithSelectonIndex:(NSInteger)index;

//结束旋转
@property (nonatomic, copy) void (^rotaryEndTurnBlock)(void);

//按下旋转按钮
@property (nonatomic, copy) void (^rotaryStartTurnBlock)(void);

@property (nonatomic, assign, getter=isShowing, readonly) BOOL showAnimationing; //正在旋转

//旋转转盘类型奖品列表数据；
-(void)lotteryDrawPrizeType:(DrawPrizeType)drawType prizeList:(NSMutableArray *)list;

//设置转盘当前类型；
-(void)lotteryRotaryLevel:(Rotary_Level)level;

@end
