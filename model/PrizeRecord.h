//
//  PrizeRecord.h
//  Ying2018
//
//  Created by qiugaoying on 2019/1/11.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrizeRecord : NSObject


@property(nonatomic,assign) NSInteger drawLogId;
@property(nonatomic,assign) BOOL bingo;  //是否中奖
@property(nonatomic,strong) NSString * betMoney;
@property(nonatomic,strong) NSString *drawName;
@property(nonatomic,strong) NSString *drawTime;
@property(nonatomic,assign) NSInteger drawType;
@property(nonatomic,strong) NSString *playType;
@property(nonatomic,strong) NSString *prizeMoney;
@property(nonatomic,assign) NSInteger propsCount;

//抽奖记录；（详情）
@property(nonatomic,assign) NSInteger prizeId;
@property(nonatomic,strong) NSString *prizeName;
@property(nonatomic,strong) NSString *remark;

/*
 
 "betMoney": 0,
 "bingo": false,
 "drawLogId": 0,
 "drawName": "string",
 "drawTime": "string",
 "drawType": 0,
 "playType": "string",
 "prizeMoney": 0,
 "propsCount": 0
*/
@end

NS_ASSUME_NONNULL_END
