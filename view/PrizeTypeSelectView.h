//
//  PrizeTypeSelectView.h
//  Ying2018
//
//  Created by qiugaoying on 2019/1/8.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PrizeTypeSelectBlock)(DrawPrizeType type);

typedef BOOL(^PrizeTypeIsCanSelectFlagBlock)(void);

@interface PrizeTypeSelectView : UIView

@property(nonatomic,strong) PrizeTypeSelectBlock selectBlock;

-(void)defaultChoosePrizeType:(DrawPrizeType)type;

@property(nonatomic,copy) PrizeTypeIsCanSelectFlagBlock bCanSelectFlagBlock;
@end

NS_ASSUME_NONNULL_END
