//
//  SportTypeListRequest.m
//  Ying2018
//
//  Created by qiugaoying on 2018/7/26.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "PrizeRecordDetailListRequest.h"

@implementation PrizeRecordDetailListRequest
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestApiCode = Http_Prize_RecordDetailList;
    }
    return self;
}

-(void) setRequestParams:(NSMutableDictionary *)params
{
    [params setObject:@(self.drawLogId) forKey:@"drawLogId"];
   
}


-(NSString *)getAPIRequestMethodName{
    
    return @"api/drawPrize/prizeDetail";
}

-(void)parseResponse:(BaseResponse *)response
{
    NSArray *modelList = [PrizeRecord mj_objectArrayWithKeyValuesArray:response.responseObject];
    response.responseObject = modelList;
}

@end
