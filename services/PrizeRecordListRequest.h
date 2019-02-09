//
//  SportTypeListRequest.h
//  Ying2018
//
//  Created by qiugaoying on 2018/7/26.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "BaseDataRequest.h"
#import "PrizeRecord.h"

@interface PrizeRecordListRequest : BaseDataRequest

@property(nonatomic,assign) NSInteger drawPrizeType;
@property(nonatomic,assign) NSInteger pageNum;
@property(nonatomic,assign) NSInteger pageSize;
@end

