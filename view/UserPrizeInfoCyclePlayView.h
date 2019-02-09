//
//  UserPrizeInfoCyclePlayView.h
//  Ying2018
//
//  Created by qiugaoying on 2019/1/9.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserPrizeInfoCyclePlayView : UIView

- (GYImage *)imageWithBarrage:(NSString *)danMuStr;
-(void)addImage:(GYImage *)image;
- (void)addTimer;
@end

NS_ASSUME_NONNULL_END
