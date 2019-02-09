//
//  PrizePlayModel.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/9.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "PrizePlayModel.h"
#import "HXQActivityPrizeModel.h"

@implementation PrizePlayModel

+(NSDictionary*)mj_objectClassInArray
{
    return @{@"prizeList":[HXQActivityPrizeModel class]};
}

@end
