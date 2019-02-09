//
//  RichBoxGift.h
//  Ying2018
//
//  Created by qiugaoying on 2019/1/11.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RichBoxGift : NSObject

@property(nonatomic,assign) BOOL hasExchanged; //是否兑换
@property(nonatomic,assign) NSInteger treasureBoxId; //礼品id
@property(nonatomic,assign) NSInteger needStar; //需要星星数
@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *money;
@property(nonatomic,copy) NSString *name;

/*
"hasExchanged": true,
"icon": "string",
"money": 0,
"name": "string",
"needStar": 0,
"treasureBoxId": 0
 */

@end

NS_ASSUME_NONNULL_END
