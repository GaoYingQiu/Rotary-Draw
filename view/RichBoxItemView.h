//
//  RichBoxItemView.h
//  Ying2018
//
//  Created by qiugaoying on 2019/1/10.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichBoxGift.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RichViewItemSelectBlock)(id model);

@interface RichBoxItemView : UIView

@property(nonatomic,copy) RichViewItemSelectBlock selectItemBlock;

-(void)fillGiftModel:(RichBoxGift *)gift PositionIndex:(NSInteger)index startCount:(NSInteger)startNum;
@end

NS_ASSUME_NONNULL_END
