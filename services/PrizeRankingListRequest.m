//
//  SportTypeListRequest.m
//  Ying2018
//
//  Created by qiugaoying on 2018/7/26.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "PrizeRankingListRequest.h"

@implementation PrizeRankingListRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestApiCode = Http_Prize_Ranking;
    }
    return self;
}

-(void) setRequestParams:(NSMutableDictionary *)params
{
    [params setObject:@(self.drawPrizeType) forKey:@"drawType"];
}


-(NSString *)getAPIRequestMethodName{
    
    return @"api/drawPrize/getRankingList";
}

-(void)parseResponse:(BaseResponse *)response
{
    NSArray *modelList = [RankingUserModel mj_objectArrayWithKeyValuesArray:response.responseObject];
    response.responseObject = modelList;
}

@end
