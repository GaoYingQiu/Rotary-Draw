//
//  RichBoxItemView.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/10.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "RichBoxItemView.h"
@interface RichBoxItemView()
@property(nonatomic,strong) UIImageView *backImageView;
@property(nonatomic,strong) UIImageView *giftIcon;
@property(nonatomic,strong) UILabel *moneyLabel1;
@property(nonatomic,strong) UILabel *numLabel1;
@property(nonatomic,strong) UIButton *coverBtn;

@property(nonatomic,strong) RichBoxGift *boxGift;

@end

@implementation RichBoxItemView
@synthesize backImageView,giftIcon,moneyLabel1,numLabel1;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *box1View = [[UIView alloc]init];
        [self addSubview:box1View];
        [box1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
        
        
        backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_chest_card_bg"]];
        [box1View addSubview:backImageView];
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(box1View);
        }];
        
        giftIcon = [[UIImageView alloc]init];
        [box1View addSubview:giftIcon];
        [giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(box1View);
            make.top.mas_equalTo(10);
            make.width.height.equalTo(@44);
        }];
        
        moneyLabel1 = [[UILabel alloc]init];
        moneyLabel1.font = LJFontMoneyText(12);
        moneyLabel1.textColor = [UIColor colorWithHexString:@"#522222"];
        moneyLabel1.textAlignment = NSTextAlignmentLeft;
        [box1View addSubview:moneyLabel1];
        [moneyLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.giftIcon);
            make.top.equalTo(self.giftIcon.mas_bottom).offset(0);
        }];
        
        numLabel1 = [[UILabel alloc]init];
        numLabel1.font = LJFontRegularText(9);
        numLabel1.textColor = [UIColor colorWithWhite:0 alpha:0.8];
        numLabel1.textAlignment = NSTextAlignmentLeft;
        [box1View addSubview:numLabel1];
        [numLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(box1View);
            make.top.equalTo(self.moneyLabel1.mas_bottom).offset(0);
        }];
        
        UIImageView *startIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_star"]];
        [box1View addSubview:startIcon];
        [startIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.numLabel1.mas_left).offset(-2);
            make.width.height.equalTo(@10);
            make.centerY.equalTo(self.numLabel1);
        }];
        
        
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coverBtn addTarget:self action:@selector(clickItemAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_coverBtn];
        [_coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

-(void)clickItemAction
{
    if(self.selectItemBlock){
        self.selectItemBlock(self.boxGift);
    }
}

-(void)fillGiftModel:(RichBoxGift *)gift PositionIndex:(NSInteger)index startCount:(NSInteger)startNum
{
    _boxGift = gift;
    //大于星星数 才点亮；
    if(startNum >= gift.needStar){
        _coverBtn.backgroundColor = [UIColor clearColor];
        if(gift.hasExchanged){
            if(index == 6 || index == 7){
                backImageView.image = [UIImage imageNamed:@"ic_chest_card_bg_redeem_big"];
            }else{
                backImageView.image = [UIImage imageNamed:@"ic_chest_card_bg_redeem"];
            }
        }else{
            if(index == 6 || index == 7){
                backImageView.image = [UIImage imageNamed:@"ic_chest_card_b"];
            }else{
                backImageView.image = [UIImage imageNamed:@"ic_chest_card_bg"];
            }
        }
    }else{
        backImageView.image = [UIImage imageNamed:@"ic_chest_card_b_grey"];
        _coverBtn.backgroundColor = [UIColor colorWithHexString:@"#929292"];
        _coverBtn.layer.opacity = 0.4;
    }
    
    [giftIcon sd_setImageWithURL:[NSURL URLWithString:gift.icon] placeholderImage:nil];
    moneyLabel1.text = gift.name; //[NSString stringWithFormat:@"￥%@",gift.money];
    numLabel1.text = [NSString stringWithFormat: @"x%ld可兑换",gift.needStar];;
}

@end
