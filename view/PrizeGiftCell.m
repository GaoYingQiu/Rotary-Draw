//
//  PrizeRankCell.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/8.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "PrizeGiftCell.h"

@implementation PrizeGiftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _numLabel = [[UILabel alloc]init];
    _numLabel.textColor = [[UIColor colorWithHexString:@"#FFA532"] colorWithAlphaComponent:0.8];
    _numLabel.font = LJFontMediumText(13);
    [self.contentView addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.icon.mas_right);
        make.centerY.equalTo(self.icon.mas_top);
    }];
    
    [self.contentView bringSubviewToFront:_numLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
