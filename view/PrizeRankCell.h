//
//  PrizeRankCell.h
//  Ying2018
//
//  Created by qiugaoying on 2019/1/8.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrizeRankCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;
@property (strong, nonatomic) UILabel *numLabel;

@end

NS_ASSUME_NONNULL_END
