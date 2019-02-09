//
//  SportTypeListRequest.m
//  Ying2018
//
//  Created by qiugaoying on 2018/7/26.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "PrizeRecordListRequest.h"

@implementation PrizeRecordListRequest
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestApiCode = Http_Prize_RecordList;
    }
    return self;
}

-(void) setRequestParams:(NSMutableDictionary *)params
{
    [params setObject:@(self.drawPrizeType) forKey:@"drawType"];
   
    [params setObject:@(self.pageNum) forKey:@"pageNum"];
    [params setObject:@(self.pageSize) forKey:@"pageSize"];
}


-(NSString *)getAPIRequestMethodName{
    
    return @"api/drawPrize/drawLog";
}

-(void)parseResponse:(BaseResponse *)response
{
    NSArray *arr = [response.dataDic objectForKey:@"drawLogList"];
    NSArray *modelList = [PrizeRecord mj_objectArrayWithKeyValuesArray:arr];
    response.responseObject = modelList;
}

@end
