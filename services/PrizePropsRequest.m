//
//  SportTypeListRequest.m
//  Ying2018
//
//  Created by qiugaoying on 2018/7/26.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "PrizePropsRequest.h"

@implementation PrizePropsRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestApiCode = Http_Prize_Props;
    }
    return self;
}

-(void) setRequestParams:(NSMutableDictionary *)params
{
    
}


-(NSString *)getAPIRequestMethodName{
    
    return @"api/drawPrize/getDrawProps";
}

-(void)parseResponse:(BaseResponse *)response
{
    HXQActivityPrizeModel *model = [HXQActivityPrizeModel mj_objectWithKeyValues:response.responseObject];
    response.responseObject = model;
}

@end
