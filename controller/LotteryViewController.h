//
//  LotteryViewController.h
//  Ying2018
//
//  Created by qiugaoying on 2019/1/3.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "ILDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LotteryViewController : ILDBaseViewController

@property (nonatomic, assign) DrawPrizeType currentDrawType; //当前转盘类型；
@property (nonatomic, assign) BOOL showAnimationing;
@end

NS_ASSUME_NONNULL_END
