//
//  SportTypeListRequest.h
//  Ying2018
//
//  Created by qiugaoying on 2018/7/26.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "BaseDataRequest.h"

@interface PrizeHotPlayRequest : BaseDataRequest

@property(nonatomic,assign) NSInteger drawPrizeType;
@end

@interface PrizeHotModel : NSObject
@property(nonatomic,assign) BOOL  crit; //是否暴击
@property(nonatomic,assign) NSInteger  critValue; //暴击值
@property(nonatomic,assign) NSInteger  remainingTime; //剩余时间；

@end


