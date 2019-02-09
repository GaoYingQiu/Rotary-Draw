//
//  SportTypeListRequest.m
//  Ying2018
//
//  Created by qiugaoying on 2018/7/26.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "PrizePlayRequest.h"

@implementation PrizePlayRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestApiCode = Http_Prize_Play;
        self.playTimeType = 1;
    }
    return self;
}

-(void) setRequestParams:(NSMutableDictionary *)params
{
    [params setObject:@(self.drawPrizeType) forKey:@"drawType"];
    [params setObject:@(self.playTimeType) forKey:@"playTimeType"]; //1 10 30
}


-(NSString *)getAPIRequestMethodName{
    
    return @"api/drawPrize/doDraw";
}

-(void)parseResponse:(BaseResponse *)response
{
    PrizePlayModel *model = [PrizePlayModel mj_objectWithKeyValues:response.responseObject];
    response.responseObject = model;
}

@end
