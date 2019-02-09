//
//  RankingUserModel.h
//  Ying2018
//
//  Created by qiugaoying on 2019/1/10.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RankingUserModel : NSObject

@property(nonatomic,strong) NSString *userName;
@property(nonatomic,assign) NSInteger userId;
@property(nonatomic,assign) NSInteger drawCount;
@property(nonatomic,strong) NSString *totalMoney;

@end

NS_ASSUME_NONNULL_END
