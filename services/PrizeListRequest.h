//
//  SportTypeListRequest.h
//  Ying2018
//
//  Created by qiugaoying on 2018/7/26.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "BaseDataRequest.h"
#import "HXQActivityPrizeModel.h"

@interface PrizeListRequest : BaseDataRequest

@property(nonatomic,assign) NSInteger drawPrizeType;
@end

