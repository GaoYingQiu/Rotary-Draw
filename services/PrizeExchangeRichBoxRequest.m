//
//  SportTypeListRequest.m
//  Ying2018
//
//  Created by qiugaoying on 2018/7/26.
//  Copyright © 2018年 qiugaoying. All rights reserved.
//

#import "PrizeExchangeRichBoxRequest.h"

@implementation PrizeExchangeRichBoxRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestApiCode = Http_Prize_ExchangeGift;
    }
    return self;
}

-(void) setRequestParams:(NSMutableDictionary *)params
{
    [params setObject:@(self.treasureBoxId) forKey:@"treasureBoxId"];
}

-(NSString *)getAPIRequestMethodName{
    
    return @"api/drawTreasureBox/exchangeTreasureBox";
}

-(void)parseResponse:(BaseResponse *)response
{
   //返回字典，包含星星数 和 宝箱礼品列表；
}

@end
