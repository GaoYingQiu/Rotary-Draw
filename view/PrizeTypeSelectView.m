//
//  PrizeTypeSelectView.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/8.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "PrizeTypeSelectView.h"

@interface PrizeTypeSelectView ()
@property(nonatomic,strong) UIButton *leftBtn;
@property(nonatomic,strong) UIButton *rightBtn;
@end

@implementation PrizeTypeSelectView
@synthesize leftBtn,rightBtn;

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
        
       
        
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor colorWithWhite:0.01 alpha:0.35];;
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
        backView.layer.masksToBounds = YES;
        backView.layer.cornerRadius = frame.size.height/2;
        
        leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setTitle:@"欢乐转盘" forState:0];
        [backView addSubview:leftBtn];
        leftBtn.tag = 1000;
        leftBtn.titleLabel.font = LJFontRegularText(16);
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [leftBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateNormal];
        leftBtn.layer.cornerRadius = frame.size.height/2;
        leftBtn.layer.masksToBounds = YES;
        [leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.4]] forState:UIControlStateSelected];
        [leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.top.mas_equalTo(0);
        }];
        
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"黄金转盘" forState:0];
        [backView addSubview:rightBtn];
        rightBtn.tag = 2000;
        rightBtn.titleLabel.font = LJFontRegularText(16);
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [rightBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateNormal];
        rightBtn.layer.cornerRadius = frame.size.height/2;
        rightBtn.layer.masksToBounds = YES;
        [rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.4]] forState:UIControlStateSelected];
        [rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.left.equalTo(self.leftBtn.mas_right).offset(0);
            make.bottom.top.mas_equalTo(0);
            make.width.equalTo(self.leftBtn);
        }];
        
        [leftBtn addTarget:self action:@selector(clickPrizeTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(clickPrizeTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        leftBtn.selected = YES;
        rightBtn.selected = NO;
        
    }
    return self;
}

-(void)clickPrizeTypeBtn:(UIButton *)sender
{
    BOOL bl = YES;
    if(self.bCanSelectFlagBlock){
        bl = !self.bCanSelectFlagBlock();
    }

    if(bl){
        self.leftBtn.selected = NO;
        self.rightBtn.selected = NO;
        sender.selected = YES;
       
        if(_selectBlock){
             if(sender.tag == 1000){
                 self.selectBlock(DrawPrize_Happy);
             }else{
                 self.selectBlock(DrawPrize_Gold);
             }
        }
    }
}

-(void)defaultChoosePrizeType:(DrawPrizeType)type
{
    if(type == DrawPrize_Happy){
        [self clickPrizeTypeBtn:self.leftBtn];
    }else{
        [self clickPrizeTypeBtn:self.rightBtn];
    }
}

@end
