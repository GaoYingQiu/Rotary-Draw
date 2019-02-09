//
//  SportTypeListRequest.m
//  Ying2018
//
//  Created by qiugaoying on 2018/7/26.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "PrizePopsMsgListRequest.h"

@implementation PrizePopsMsgListRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestApiCode = Http_Prize_PopsList;
    }
    return self;
}

-(void) setRequestParams:(NSMutableDictionary *)params
{
    
}


-(NSString *)getAPIRequestMethodName{
    
    return @"api/drawPrize/barrage";
}

-(void)parseResponse:(BaseResponse *)response
{
  
}

@end
