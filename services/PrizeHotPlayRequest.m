//
//  SportTypeListRequest.m
//  Ying2018
//
//  Created by qiugaoying on 2018/7/26.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "PrizeHotPlayRequest.h"

@implementation PrizeHotPlayRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestApiCode = Http_Prize_CritValue;
    }
    return self;
}

-(void) setRequestParams:(NSMutableDictionary *)params
{
    [params setObject:@(self.drawPrizeType) forKey:@"drawType"];
}


-(NSString *)getAPIRequestMethodName{
    
    return @"api/drawPrize/crit";
}

-(void)parseResponse:(BaseResponse *)response
{
    PrizeHotModel *model = [PrizeHotModel mj_objectWithKeyValues:response.responseObject];
    response.responseObject = model;
}

@end


@implementation PrizeHotModel

@end
