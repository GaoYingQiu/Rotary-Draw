//
//  SportTypeListRequest.h
//  Ying2018
//
//  Created by qiugaoying on 2018/7/26.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "BaseDataRequest.h"
#import "PrizePlayModel.h"

@interface PrizePlayRequest : BaseDataRequest

@property(nonatomic,assign) NSInteger drawPrizeType;
@property(nonatomic,assign) NSInteger playTimeType; //1单抽  10连抽 30连抽
@end

