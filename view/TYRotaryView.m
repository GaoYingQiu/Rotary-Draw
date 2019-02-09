//
//  TYRotaryView.m
//  TYRotaryDemo
//
//  Created by Qiugaoying on 2018/5/14.
//  Copyright © 2018年 hxq. All rights reserved.
//
#import "TYRotaryView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "HXQActivityPrizeModel.h"
#import "UIView+AnimationProperty.h"

#define pointRotatedAroundAnchorPoint(point,anchorPoint,angle) CGPointMake((point.x-anchorPoint.x)*cos(angle) - (point.y-anchorPoint.y)*sin(angle) + anchorPoint.x, (point.x-anchorPoint.x)*sin(angle) + (point.y-anchorPoint.y)*cos(angle)+anchorPoint.y)

//原文：https://blog.csdn.net/like_sky_/article/details/72822176

@interface TYRotaryView ()<CAAnimationDelegate>

@property(nonatomic,assign) Rotary_Level rotaryLevel;

@property (nonatomic, strong) UIImageView *gameBgView;
@property (nonatomic, assign) CGFloat lastAngle;
@property (nonatomic, strong) UIImageView *needleImgView;
@property (nonatomic, strong) UIImageView *textImgView;

@property (nonatomic, assign) CGFloat  perSection;
@property (nonatomic, assign) CGFloat  perPointSection;

@property (nonatomic, strong) UIImageView *icon1;
@property (nonatomic, strong) UIImageView *icon2;
@property (nonatomic, strong) UIImageView *icon3;
@property (nonatomic, strong) UIImageView *icon4;
@property (nonatomic, strong) UIImageView *icon5;
@property (nonatomic, strong) UIImageView *icon6;
@property (nonatomic, strong) UIImageView *icon7;
@property (nonatomic, strong) UIImageView *icon8;
@property (nonatomic, strong) UIImageView *icon9;

@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) UILabel *label5;
@property (nonatomic, strong) UILabel *label6;
@property (nonatomic, strong) UILabel *label7;
@property (nonatomic, strong) UILabel *label8;
@property (nonatomic, strong) UILabel *label9;

@end

@implementation TYRotaryView
@synthesize icon1,icon2,icon3,icon4,icon5,icon6,icon7,icon8,icon9,label1,label2,label3,label4,label5,label6,label7,label8,label9;

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
  
    //默认欢乐状态；
    _perSection = M_PI*2/9;
    _perPointSection = M_PI*2/18;
    
    self.gameBgView = [UIImageView new];
    self.gameBgView.layer.masksToBounds = YES;
    self.gameBgView.layer.cornerRadius =  (([UIScreen mainScreen].bounds.size.width) - 100)*0.5f;
    [self addSubview:self.gameBgView];
    [self.gameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    
    
    CGFloat icon_W = 33;
    CGFloat label_W = 40; //50
    CGFloat label_H = 15;
    UIFont *moneyFont = LJFontMoneyText(10);
    icon1 = [UIImageView new];
    [self.gameBgView addSubview:icon1];
    icon1.frame = CGRectMake(0, 0, icon_W, icon_W);
 
    
    label1 = [[UILabel alloc]init];
    label1.font = moneyFont;
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.gameBgView addSubview:label1];
    label1.frame = CGRectMake(0, 0, label_W, label_H);
 
    
    icon2 = [UIImageView new];
    [self.gameBgView addSubview:icon2];
    icon2.frame = CGRectMake(0, 0, icon_W, icon_W);

    
    label2 = [[UILabel alloc]init];
    label2.font = moneyFont;
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [self.gameBgView addSubview:label2];
    label2.frame = CGRectMake(0, 0, label_W, label_H);
   
    
    icon3 = [UIImageView new];
    [self.gameBgView addSubview:icon3];
    icon3.frame = CGRectMake(0, 0, icon_W, icon_W);
    
    
    label3 = [[UILabel alloc]init];
    label3.font = moneyFont;
    label3.textColor = [UIColor whiteColor];
    label3.textAlignment = NSTextAlignmentCenter;
    [self.gameBgView addSubview:label3];
    label3.frame = CGRectMake(0, 0, label_W, label_H);
   
    
   
    icon4 = [UIImageView new];
    [self.gameBgView addSubview:icon4];
    icon4.frame = CGRectMake(0, 0, icon_W, icon_W);
    
    
    label4 = [[UILabel alloc]init];
    label4.font = moneyFont;
    label4.textColor = [UIColor whiteColor];
    label4.textAlignment = NSTextAlignmentCenter;
    [self.gameBgView addSubview:label4];
    label4.frame = CGRectMake(0, 0, label_W, label_H);
  
    
    icon5 = [UIImageView new];
    [self.gameBgView addSubview:icon5];
    icon5.frame = CGRectMake(0, 0, icon_W, icon_W);
    
   
    
    label5 = [[UILabel alloc]init];
    label5.font = moneyFont;
    label5.textColor = [UIColor whiteColor];
    label5.textAlignment = NSTextAlignmentCenter;
    [self.gameBgView addSubview:label5];
    label5.frame = CGRectMake(0, 0, label_W, label_H);
    
    
    
    icon6 = [UIImageView new];
    [self.gameBgView addSubview:icon6];
    icon6.frame = CGRectMake(0, 0, icon_W, icon_W);
    
  
    
    label6 = [[UILabel alloc]init];
    label6.font = moneyFont;
    label6.textColor = [UIColor whiteColor];
    label6.textAlignment = NSTextAlignmentCenter;
    [self.gameBgView addSubview:label6];
    label6.frame = CGRectMake(0, 0, label_W, label_H);
   
    
    
    icon7 = [UIImageView new];
    [self.gameBgView addSubview:icon7];
    icon7.frame = CGRectMake(0, 0, icon_W, icon_W);
    

    
    label7 = [[UILabel alloc]init];
    label7.font = moneyFont;
    label7.textColor = [UIColor whiteColor];
    label7.textAlignment = NSTextAlignmentCenter;
    [self.gameBgView addSubview:label7];
    label7.frame = CGRectMake(0, 0, label_W, label_H);
    
    
    icon8 = [UIImageView new];
    [self.gameBgView addSubview:icon8];
    icon8.frame = CGRectMake(0, 0, icon_W, icon_W);
    
    
    label8 = [[UILabel alloc]init];
    label8.font = moneyFont;
    label8.textColor = [UIColor whiteColor];
    label8.textAlignment = NSTextAlignmentCenter;
    [self.gameBgView addSubview:label8];
    label8.frame = CGRectMake(0, 0, label_W, label_H);
   
    
    
    icon9 = [UIImageView new];
    [self.gameBgView addSubview:icon9];
    icon9.frame = CGRectMake(0, 0, icon_W, icon_W);
    
   
    
    label9 = [[UILabel alloc]init];
    label9.font = moneyFont;
    label9.textColor = [UIColor whiteColor];
    label9.textAlignment = NSTextAlignmentCenter;
    [self.gameBgView addSubview:label9];
    label9.frame = CGRectMake(0, 0, label_W, label_H);
    
    
    self.startButton = [UIButton new];
    [self.startButton setImage:[UIImage imageNamed:@"turntable_fun_point"]  forState:UIControlStateNormal];//按钮；
     [self.startButton setImage:[UIImage imageNamed:@"turntable_fun_point"]  forState:UIControlStateDisabled];
    [self.startButton addTarget:self action:@selector(itemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.startButton];
    
    self.textImgView = [UIImageView new];
    self.textImgView.image = [UIImage imageNamed:@"lottery_state_start"]; //点击抽奖
    [self addSubview:self.textImgView];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    [self.needleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_centerY).mas_offset(15);
    }];
    
    [self.textImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    label1.backgroundColor = [UIColor clearColor];
    label2.backgroundColor =  label1.backgroundColor;
     label3.backgroundColor =  label1.backgroundColor;
     label4.backgroundColor =  label1.backgroundColor;
     label5.backgroundColor =  label1.backgroundColor;
     label6.backgroundColor =  label1.backgroundColor;
     label7.backgroundColor =  label1.backgroundColor;
    label8.backgroundColor =  label1.backgroundColor;
    label9.backgroundColor =  label1.backgroundColor;
}

//跳转 Icon  和 title 的位置；
-(void)refrehIconAndTitlePosition
{
    CGFloat o_w = (SCREEN_W-100)/2; //圆半径
    CGPoint pointCenter = CGPointMake(o_w, o_w);
    CGPoint point0 = CGPointMake(o_w, o_w/2); //起点；
    CGPoint labelPoint0 = CGPointMake(o_w, 33); //起点；
    
    if(self.rotaryLevel == Rotary_Level_Happly){
//        让起点便宜5度；
        point0 = pointRotatedAroundAnchorPoint(point0,pointCenter,M_PI/36);
       labelPoint0 = pointRotatedAroundAnchorPoint(labelPoint0,pointCenter,M_PI/36);
    }
    
    
    CGPoint point1 = pointRotatedAroundAnchorPoint(point0,pointCenter,_perPointSection);
    icon1.center = point1;
    CGPoint labelPoint1 = pointRotatedAroundAnchorPoint(labelPoint0,pointCenter,_perPointSection);
    if(self.rotaryLevel != Rotary_Level_Happly){
        labelPoint1 = pointRotatedAroundAnchorPoint(labelPoint1,pointCenter,M_PI/72);
    }
    
    label1.center = labelPoint1;
    label1.transform = CGAffineTransformMakeRotation(_perPointSection);
    
    CGPoint point2 = pointRotatedAroundAnchorPoint(point0,pointCenter,_perPointSection*3);
    icon2.center = point2;
    CGPoint labelPoint2 = pointRotatedAroundAnchorPoint(labelPoint0,pointCenter,_perPointSection*3);
    label2.center = labelPoint2;
    label2.transform = CGAffineTransformMakeRotation(_perPointSection*3);
    
    CGPoint point3 = pointRotatedAroundAnchorPoint(point0,pointCenter,_perPointSection*5);
    icon3.center = point3;
    CGPoint labelPoint3 = pointRotatedAroundAnchorPoint(labelPoint0,pointCenter,_perPointSection*5);
    
    if(self.rotaryLevel != Rotary_Level_Happly){
        labelPoint3 = pointRotatedAroundAnchorPoint(labelPoint3,pointCenter,-M_PI/72);
    }
    label3.center = labelPoint3;
    label3.transform = CGAffineTransformMakeRotation(_perPointSection*5);
    
    
    CGPoint point4 = pointRotatedAroundAnchorPoint(point0,pointCenter,_perPointSection*7);
    icon4.center = point4;
    CGPoint labelPoint4 = pointRotatedAroundAnchorPoint(labelPoint0,pointCenter,_perPointSection*7);
    label4.center = labelPoint4;
    label4.transform = CGAffineTransformMakeRotation(_perPointSection*7);
    
    CGPoint point5 = pointRotatedAroundAnchorPoint(point0,pointCenter,_perPointSection*9);
    icon5.center = point5;
    CGPoint labelPoint5 = pointRotatedAroundAnchorPoint(labelPoint0,pointCenter,_perPointSection*9);
    
    if(self.rotaryLevel == Rotary_Level_Happly){
       labelPoint5 = pointRotatedAroundAnchorPoint(labelPoint5,pointCenter,-M_PI/72);
    }
    
    label5.center = labelPoint5;
    label5.transform = CGAffineTransformMakeRotation(_perPointSection*9);
    
    CGPoint point6 = pointRotatedAroundAnchorPoint(point0,pointCenter,_perPointSection*11);
    icon6.center = point6;
    CGPoint labelPoint6 = pointRotatedAroundAnchorPoint(labelPoint0,pointCenter,_perPointSection*11);
    label6.center = labelPoint6;
    label6.transform = CGAffineTransformMakeRotation(_perPointSection*11);
    
    CGPoint point7 = pointRotatedAroundAnchorPoint(point0,pointCenter,_perPointSection*13);
    icon7.center = point7;
    CGPoint labelPoint7 = pointRotatedAroundAnchorPoint(labelPoint0,pointCenter,_perPointSection*13);
    
    if(self.rotaryLevel != Rotary_Level_Happly){
        labelPoint7 = pointRotatedAroundAnchorPoint(labelPoint7,pointCenter,-M_PI/72);
    }
    
    label7.center = labelPoint7;
    label7.transform = CGAffineTransformMakeRotation(_perPointSection*13);
    
    CGPoint point8 = pointRotatedAroundAnchorPoint(point0,pointCenter,_perPointSection*15);
    icon8.center = point8;
    CGPoint labelPoint8 = pointRotatedAroundAnchorPoint(labelPoint0,pointCenter,_perPointSection*15);
    label8.center = labelPoint8;
    label8.transform = CGAffineTransformMakeRotation(_perPointSection*15);
    
    
    CGPoint point9 = pointRotatedAroundAnchorPoint(point0,pointCenter,_perPointSection*17);
    icon9.center = point9;
    CGPoint labelPoint9 = pointRotatedAroundAnchorPoint(labelPoint0,pointCenter,_perPointSection*17);
    
    if(self.rotaryLevel == Rotary_Level_Happly){
        labelPoint9 = pointRotatedAroundAnchorPoint(labelPoint9,pointCenter,-M_PI/72);
    }
    
    label9.center = labelPoint9;
    label9.transform = CGAffineTransformMakeRotation(_perPointSection*17);
}

-(void)lotteryDrawPrizeType:(DrawPrizeType)drawType prizeList:(NSMutableArray *)list
{

    
    //欢乐转盘
    NSInteger maxNum = 9;
    _perSection = M_PI*2/9;
    _perPointSection = (M_PI*2/18);
    
    if(drawType == DrawPrize_Gold){
        //黄金转盘
        maxNum = 7;
        _perSection = M_PI*2/7;
        _perPointSection = M_PI*2/14;
    }
    
    [self refrehIconAndTitlePosition];
    
    NSInteger len = list.count>maxNum ? maxNum : list.count;
    for(NSInteger i=0; i<len; i++){
        
        HXQActivityPrizeModel *prize = [list objectAtIndex:i];
        switch (i) {
            case 0:
            {
                [self.icon1 sd_setImageWithURL:[NSURL URLWithString:prize.prizeIcon] placeholderImage:nil];
                self.label1.text =  prize.prizeName;
                
            }
                break;
            case 1:
            {
               [self.icon2 sd_setImageWithURL:[NSURL URLWithString:prize.prizeIcon] placeholderImage:nil];
                self.label2.text = prize.prizeName;
            }
                break;
            case 2:
            {
                [self.icon3 sd_setImageWithURL:[NSURL URLWithString:prize.prizeIcon] placeholderImage:nil];
                self.label3.text =  prize.prizeName;
            }
                break;
            case 3:
            {
                [self.icon4 sd_setImageWithURL:[NSURL URLWithString:prize.prizeIcon] placeholderImage:nil];
                self.label4.text =  prize.prizeName;
            }
                break;
            case 4:
            {
                [self.icon5 sd_setImageWithURL:[NSURL URLWithString:prize.prizeIcon] placeholderImage:nil];
                self.label5.text =  prize.prizeName;
            }
                break;
            case 5:
            {
                [self.icon6 sd_setImageWithURL:[NSURL URLWithString:prize.prizeIcon] placeholderImage:nil];
                self.label6.text =  prize.prizeName;
            }
                break;
            case 6:
            {
                [self.icon7 sd_setImageWithURL:[NSURL URLWithString:prize.prizeIcon] placeholderImage:nil];
                self.label7.text =  prize.prizeName;
            }
                break;
            case 7:
            {
                [self.icon8 sd_setImageWithURL:[NSURL URLWithString:prize.prizeIcon] placeholderImage:nil];
                self.label8.text =  prize.prizeName;
            }
                break;
            case 8:
            {
                [self.icon9 sd_setImageWithURL:[NSURL URLWithString:prize.prizeIcon] placeholderImage:nil];
                self.label9.text =  prize.prizeName;
            }
                break;
            default:
                break;
        }
    }
}


-(void)itemClick{
    if (self.rotaryStartTurnBlock) {
        self.rotaryStartTurnBlock();
    }
}

-(void)lotteryRotaryLevel:(Rotary_Level)level
{
    _rotaryLevel = level;
    if(level == Rotary_Level_Happly){
        label1.textColor = LJOrangeColor;
        label2.textColor =  label1.textColor;
        label3.textColor =  label1.textColor;
        label4.textColor =  label1.textColor;
        label5.textColor =  label1.textColor;
        label6.textColor =  label1.textColor;
        label7.textColor =  label1.textColor;
        label8.textColor =  label1.textColor;
        label9.textColor =  label1.textColor;
        
        self.gameBgView.image =  [UIImage imageNamed:@"turntable_fun_bg"]; //欢乐转盘
        self.gameBgView.transform = CGAffineTransformMakeRotation(M_PI * (-5) / 180.0);
        [self.startButton setImage:[UIImage imageNamed:@"turntable_fun_point"]  forState:UIControlStateNormal];
    }else  if(level == Rotary_Level_Crit){
        self.gameBgView.image =  [UIImage imageNamed:@"turntable_crit_bg"]; //黄金转盘
        [self.startButton setImage:[UIImage imageNamed:@"turntable_crit_point"]  forState:UIControlStateNormal];
         [self.startButton setImage:[UIImage imageNamed:@"turntable_crit_point"]  forState:UIControlStateDisabled];
    }else{
        self.gameBgView.image =  [UIImage imageNamed:@"turntable_gold_bg"]; //燃烧状态；
        [self.startButton setImage:[UIImage imageNamed:@"turntable_gold_point"]  forState:UIControlStateNormal];
          [self.startButton setImage:[UIImage imageNamed:@"turntable_gold_point"]  forState:UIControlStateDisabled];
    }
}


-(void)animationWithSelectonIndex:(NSInteger)index{
    
    [self backToStartPosition];
    self.startButton.enabled = NO;
    self.textImgView.image =nil;
//    self.textImgView.image = [UIImage imageNamed:@"lottery_state_zhong"];
    CABasicAnimation *layer = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    //先转4圈 再选区 顺时针(所有这里需要用360-对应的角度) 逆时针不需要
    layer.toValue = @((M_PI*2 - (_perSection*index +_perSection*0.5)) + M_PI*2*4);
    layer.duration = 4;
    layer.removedOnCompletion = NO;
    layer.fillMode = kCAFillModeForwards;
    layer.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    layer.delegate = self;
    
    [self.gameBgView.layer addAnimation:layer forKey:nil];
}

-(void)backToStartPosition{
//    [self lotteryRotaryLevel:self.rotaryLevel];
//    [self.gameBgView.layer removeAllAnimations];
    CABasicAnimation *layer = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    layer.toValue = @(0);
    layer.duration = 0.001;
    layer.removedOnCompletion = NO;
    layer.fillMode = kCAFillModeForwards;
    [self.gameBgView.layer addAnimation:layer forKey:nil];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    self->_showAnimationing = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    self->_showAnimationing = NO;
    //设置指针返回初始位置
    self.startButton.enabled = YES;
    self.textImgView.image = [UIImage imageNamed:@"lottery_state_start"];
    if (self.rotaryEndTurnBlock) {
        self.rotaryEndTurnBlock();
    }
}
@end
