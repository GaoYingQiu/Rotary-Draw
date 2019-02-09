//
//  HXQActivityPrizeModel.h
//  hxquan
//
//  Created by Qiugaoying on 2018/5/17.
//  Copyright © 2018年 Tiny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXQActivityPrizeModel : NSObject

@property(nonatomic,assign) NSInteger drawType; //转盘类型 1:欢乐 2：黄金
@property (nonatomic, copy) NSString *prizeIcon;
@property (nonatomic, assign) NSInteger prizeId;  //奖品ID
@property (nonatomic, copy) NSString *prizeMoney;
@property (nonatomic, copy) NSString *prizeName; //奖品名称
@property (nonatomic, assign) NSInteger prizeType;  //0 空奖， 1 奖品； 3道具

/*以下是奖品属性*/
@property (nonatomic, copy) NSString *desc; //描述；
@property (nonatomic, assign) NSInteger count; //数量

/*以下是技能属性*/
@property (nonatomic, assign) NSInteger rtimes; //次数；
//{
//    "count": 0,
//    "prizeIcon": "string",
//    "prizeName": "string",
//    "rtimes": 0
//}
@end
