//
//  HXQPrizePopView.h
//  hxquan
//
//  Created by Qiugaoying on 2018/5/21.
//  Copyright © 2018年 Tiny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichBoxGift.h"

@class HXQActivityPrizeModel;
@interface HXQPrizePopView : UIView

-(void)showWithModel:(RichBoxGift *)model;
-(void)dismiss; //消失

@property (nonatomic, copy) void (^popShareBlock)(void);

@end
