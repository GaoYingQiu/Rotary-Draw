//
//  PrizeRankTableView.h
//  Ying2018
//
//  Created by qiugaoying on 2019/1/8.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PrizeRankTableViewDelegate <NSObject>

-(void)goLookMoreRankingPage;

@end

@interface PrizeRankTableView : UIView
@property(nonatomic,assign) BOOL bNeedHeaderViewFlag; //需要头部；
@property(nonatomic,assign) DrawPrizeType drawType; //转盘类型；

//@property(nonatomic,assign) BOOL canRefresh;
//@property(nonatomic,assign) BOOL canLoadMore;
@property(nonatomic,weak) id<PrizeRankTableViewDelegate> delegate;
@end
