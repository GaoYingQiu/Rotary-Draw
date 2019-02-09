//
//  PrizeRankCell.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/8.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "PrizeRankCell.h"

@implementation PrizeRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _numLabel = [[UILabel alloc]init];
    _numLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    _numLabel.font = LJFontMoneyText(14);
    [self.contentView addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.icon);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
