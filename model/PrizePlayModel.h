//
//  PrizePlayModel.h
//  Ying2018
//
//  Created by qiugaoying on 2019/1/9.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrizePlayModel : NSObject

@property (nonatomic, assign) BOOL bingo; //是否中奖
@property (nonatomic, assign) NSInteger prizeId; //奖品id
@property (nonatomic, strong) NSArray *prizeList;

@property (nonatomic, strong) NSString * totalMoney; //余额
@end

NS_ASSUME_NONNULL_END
