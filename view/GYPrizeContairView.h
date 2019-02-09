//
//  ShareTourView.h
//  ChatDemo-UI2.0
//
//  Created by xiatian on 16/7/7.
//  Copyright © 2016年 xiatian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrizeRecord.h"

typedef void(^GYActionDateDoneBlock)(id selectedDate);

typedef enum : NSInteger {
    Prize_Ranking, //抽奖
    Prize_Gift, //奖品
    Prize_SkillDesc, //描述
    Prize_PlayDesc, //描述
    Prize_Record, //中奖记录
    Prize_RecordDetail //中奖详情
} PrizeStyle;

@interface GYPrizeContairView : UIView

- (instancetype)initSheetStyle:(PrizeStyle)prizeStyle actionBlock:(GYActionDateDoneBlock)actionDateDoneBlock;

-(void)showInView;

//中奖奖品；
-(void)fetch_Prize_Gift:(NSArray *)datas;

//默认选中查询的转盘
-(void)fetch_Record_DefaultChooseSelect:(DrawPrizeType)drawType;
-(void)fetch_Record_Detail:(PrizeRecord *)record;

//排行榜
-(void)fetch_Ranking_DrawType:(DrawPrizeType)drawType;

@end
