//
//  HXQPrizePopView.m
//  hxquan
//
//  Created by Qiugaoying on 2018/5/21.
//  Copyright © 2018年 Tiny. All rights reserved.
//

#import "HXQPrizePopView.h"
#import "HXQActivityPrizeModel.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#define APP_IMG(imgUrl)  [NSURL URLWithString:[imgUrl hasPrefix:@"http"] ? imgUrl : [NSString stringWithFormat:@"https:%@",imgUrl]]

@interface HXQPrizePopView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) RichBoxGift *model;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation HXQPrizePopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.bounds = [UIScreen mainScreen].bounds;
    self.maskView = [UIView new];
    [self addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
    //设置ImgeView
    UIView *centerView = [UIView new];
//    centerView.layer.cornerRadius = 10;
    [centerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adTouchAction)]];
//    centerView.backgroundColor = [UIColor whiteColor];
    [self.maskView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.maskView);
        make.size.mas_equalTo(CGSizeMake(246, 262));
    }];
    
    UIImageView *rightImgView = [UIImageView new];
    rightImgView.image = [UIImage imageNamed:@"prize_alertBackground"];
    [centerView addSubview:rightImgView];
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(centerView);
    }];
    
    self.imgView = [UIImageView new];
    [centerView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(centerView);
        make.top.mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(100,100));
    }];
    
    self.moneyLabel = [UILabel new];
    self.moneyLabel.font = LJFontMoneyText(28);
    self.moneyLabel.textColor = [UIColor colorWithHexString:@"#522222"];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(centerView);
        make.top.mas_equalTo(self.imgView.mas_bottom).mas_offset(0);
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = LJFontRegularText(12);
    self.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:0.8];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [centerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(centerView);
        make.top.mas_equalTo(self.moneyLabel.mas_bottom).mas_offset(0);
    }];
    
    UIImageView *startIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_star"]];
    [centerView addSubview:startIcon];
    [startIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel.mas_left).offset(-2);
        make.width.height.equalTo(@15);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    
    UIButton *shareButton = [UIButton new];
    shareButton.layer.cornerRadius = 36*0.5;
    shareButton.layer.masksToBounds = YES;
    [shareButton setTitleColor:[UIColor colorWithWhite:0 alpha:0.7] forState:0];
    shareButton.titleLabel.font = LJFontMediumText(16);
    [shareButton setTitle:@"立即领取" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 36));
        make.bottom.mas_equalTo(-23);
        make.centerX.mas_equalTo(centerView);
    }];
    
    [shareButton layoutIfNeeded];
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#EAC793"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#A7854A"].CGColor];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 0);
    layer.frame = shareButton.bounds;
    [shareButton.layer insertSublayer:layer atIndex:0];
    
    
    self.closeButton = [UIButton new];
    [self.closeButton setImage:[UIImage imageNamed:@"ic_close_big"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:self.closeButton];

    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(centerView.mas_centerX);
        make.height.width.equalTo(@35);
    }];
}

-(void)shareAction{
    NSLog(@"分享");
    if (self.popShareBlock) {
        self.popShareBlock();
    }
}

-(void)adTouchAction{
    
}

-(void)showWithModel:(RichBoxGift *)model{
    self.model = model;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
    self.moneyLabel.text = model.name;
    self.titleLabel.text = [NSString stringWithFormat:@"×%ld可兑换",model.needStar];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
    //让视图显示出来
    self.maskView.layer.position = self.center;
    self.maskView.transform = CGAffineTransformMakeScale(0.80, 0.80);
    [UIView animateWithDuration:0.25 delay:0.05 usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.maskView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dismiss{
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0;
        self.maskView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
