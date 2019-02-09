

#import "GYPrizeRichBoxView.h"
#import "ILDScreenshotImageManager.h"
#import "GYPrizeRichBoxView.h"
#import "RichBoxItemView.h"
#import "HXQPrizePopView.h"
#import "MBProgressHUD+YF.h"
#import "PrizeRichBoxListRequest.h"
#import "RichBoxGift.h"
#import "PrizeExchangeRichBoxRequest.h"

@interface GYPrizeRichBoxView ()<DataRequestDelegate>

@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIView *doneView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) HXQPrizePopView *popView;
@property (nonatomic,assign) NSInteger selectedIndex; //当前选中的
@property (nonatomic,strong) UILabel *startNumLabel;
@property (nonatomic,assign) NSInteger myStartNum; //我的宝箱星星数；

@property(nonatomic,strong) UIImageView *backgroundImageView;
@property(nonatomic,strong) RichBoxItemView *richBoxItem1View;
@property(nonatomic,strong) RichBoxItemView *richBoxItem2View;
@property(nonatomic,strong) RichBoxItemView *richBoxItem3View;
@property(nonatomic,strong) RichBoxItemView *richBoxItem4View;
@property(nonatomic,strong) RichBoxItemView *richBoxItem5View;
@property(nonatomic,strong) RichBoxItemView *richBoxItem6View;
@property(nonatomic,strong) RichBoxItemView *richBoxItem7View;
@property(nonatomic,strong) RichBoxItemView *richBoxItem8View;

@property(nonatomic,strong) UIView *line1;
@property(nonatomic,strong) UIView *line2;
@property(nonatomic,strong) UIView *line3;
@property(nonatomic,strong) UIView *line4;
@property(nonatomic,strong) UIView *line5;
@property(nonatomic,strong) UIView *line6;
@property(nonatomic,strong) UIView *line7;

@end

@implementation GYPrizeRichBoxView

- (instancetype)initSheetRichBox{
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
 
        //创建视图；
        [self _initSetUp];
    }
    return self;
}

-(void)showInView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
 
    [UIView animateWithDuration:0.33 animations:^{
    
        self.containerView.frame = CGRectMake(0, SCREEN_H/2 - 50, SCREEN_W ,  SCREEN_H/2 + 50);
    }];
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
}

#pragma mark - Getter and Setter

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [ILDScreenshotImageManager sharedInstance].screenshotImage;
    }
    
    return _backgroundImageView;
}

- (void)_initSetUp {
    
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
//    self.containerView.backgroundColor = [UIColor colorWithWhite:0.01 alpha:0.9];
    
    [self.containerView addSubview:self.backgroundImageView];
    self.backgroundImageView.layer.opacity = 0.975;
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.containerView];
    
    //工具类
    _doneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 55)];
    
    [self.containerView addSubview:self.doneView];
    UIImageView *iconBackIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_go_prize"]];
    [_doneView addSubview:iconBackIcon];
    [iconBackIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.width.height.equalTo(@22);
        make.centerY.mas_equalTo(self.doneView);
    }];
    
    [_doneView addSubview:self.cancelBtn];
    self.cancelBtn.backgroundColor = [UIColor clearColor];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.center.equalTo(iconBackIcon);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = LJFontRegularText(12);
    titleLabel.text = @"所有星星清空时间：每周日23:59:59";
    titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [_doneView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconBackIcon.mas_right).offset(5);
        make.top.mas_equalTo(8);
    }];
    
    UILabel *descLabel = [[UILabel alloc]init];
    descLabel.font = LJFontRegularText(12);
    descLabel.text = @"每进行一次黄金转盘，增加一颗星星";
    descLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    descLabel.textAlignment = NSTextAlignmentLeft;
    [_doneView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(2);
        make.left.equalTo(titleLabel);
    }];
    
    UIView *rightStartView = [[UIView alloc]init];
    rightStartView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    [_doneView addSubview:rightStartView];
    [rightStartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.equalTo(@77);
        make.height.equalTo(@22);
        make.centerY.mas_equalTo(self.doneView);
    }];
    rightStartView.layer.cornerRadius = 2;
    rightStartView.layer.masksToBounds = YES;
    
    UIImageView *startIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_star"]];
    [rightStartView addSubview:startIcon];
    [startIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@15);
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(rightStartView);
    }];
    
    _startNumLabel = [[UILabel alloc]init];
    _startNumLabel.font = LJFontMoneyText(14);
    _startNumLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    _startNumLabel.textAlignment = NSTextAlignmentLeft;
    [rightStartView addSubview:_startNumLabel];
    [_startNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(rightStartView);
        make.right.mas_equalTo(-6);
        make.left.equalTo(startIcon.mas_right).offset(0);
    }];
    
    [self createBoxesView];
}


-(void)setMyStartNum:(NSInteger)myStartNum
{
    _myStartNum = myStartNum;
    _startNumLabel.text = [NSString stringWithFormat:@"：%ld",_myStartNum];
}

-(void)createBoxesView
{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [self.containerView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(55);
        make.bottom.mas_equalTo(0);
    }];
    
    UIView *scrollContentView = [[UIView alloc]init];
    [scrollView addSubview:scrollContentView];
    [scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.equalTo(@(SCREEN_W));
    }];
    
    CGFloat boxWidth = 80;
    CGFloat boxHeight = 90;
    CGFloat lineHeight = 7;
    
    MJWeakSelf
    //box1
    _richBoxItem1View = [[RichBoxItemView alloc]initWithFrame:CGRectZero];
    _richBoxItem1View.selectItemBlock = ^(id  _Nonnull model) {
         [weakSelf exchangePrizeGift:model];
    };
    [scrollContentView addSubview:_richBoxItem1View];
    [_richBoxItem1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(8);
        make.size.equalTo(@(CGSizeMake(boxWidth, boxHeight)));
    }];
    
    
    //box2
    _richBoxItem2View = [[RichBoxItemView alloc]initWithFrame:CGRectZero];
    _richBoxItem2View.selectItemBlock = ^(id  _Nonnull model) {
        [weakSelf exchangePrizeGift:model];
    };
    
    [scrollContentView addSubview:_richBoxItem2View];
    [_richBoxItem2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView);
        make.top.mas_equalTo(8);
        make.size.equalTo(@(CGSizeMake(boxWidth, boxHeight)));
    }];
    
    _line1 = [[UIView alloc]init];
    [scrollContentView addSubview:_line1];
    _line1.backgroundColor = [UIColor colorWithHexString:@"#FC6C6B"];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.richBoxItem1View.mas_right).offset(0);
        make.right.equalTo(self.richBoxItem2View.mas_left).offset(0);
        make.height.equalTo(@(lineHeight));
        make.centerY.equalTo(self.richBoxItem1View);
    }];
    
    //box3
    _richBoxItem3View = [[RichBoxItemView alloc]initWithFrame:CGRectZero];
    _richBoxItem3View.selectItemBlock = ^(id  _Nonnull model) {
         [weakSelf exchangePrizeGift:model];
    };
    [scrollContentView addSubview:_richBoxItem3View];
    [_richBoxItem3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(8);
        make.size.equalTo(@(CGSizeMake(boxWidth, boxHeight)));
    }];
   
    _line2 = [[UIView alloc]init];
    [scrollContentView addSubview:_line2];
    _line2.backgroundColor = [UIColor colorWithHexString:@"#FE8A52"];
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.richBoxItem2View.mas_right).offset(0);
        make.right.equalTo(self.richBoxItem3View.mas_left).offset(0);
        make.height.equalTo(@(lineHeight));
        make.centerY.equalTo(self.richBoxItem1View);
    }];
    
    
    //box4
    _richBoxItem4View = [[RichBoxItemView alloc]initWithFrame:CGRectZero];
    _richBoxItem4View.selectItemBlock = ^(id  _Nonnull model) {
         [weakSelf exchangePrizeGift:model];
    };
    [scrollContentView addSubview:_richBoxItem4View];
    [_richBoxItem4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.richBoxItem3View.mas_right);
        make.top.equalTo(self.richBoxItem3View.mas_bottom).offset(20);
        make.size.equalTo(@(CGSizeMake(boxWidth, boxHeight)));
    }];

    
    _line3 = [[UIView alloc]init];
    [scrollContentView addSubview:_line3];
    _line3.backgroundColor = [UIColor colorWithHexString:@"#FE8A52"];
    [_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.richBoxItem3View.mas_bottom).offset(0);
        make.bottom.equalTo(self.richBoxItem4View.mas_top).offset(0);
        make.width.equalTo(@(lineHeight));
        make.centerX.equalTo(self.richBoxItem3View);
    }];
    
    
    
    //box5
    _richBoxItem5View = [[RichBoxItemView alloc]initWithFrame:CGRectZero];
    _richBoxItem5View.selectItemBlock = ^(id  _Nonnull model) {
         [weakSelf exchangePrizeGift:model];
    };
    [scrollContentView addSubview:_richBoxItem5View];
    [_richBoxItem5View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView);
        make.top.equalTo(self.richBoxItem2View.mas_bottom).offset(20);
        make.size.equalTo(@(CGSizeMake(boxWidth, boxHeight)));
    }];
    
    _line4 = [[UIView alloc]init];
    [scrollContentView addSubview:_line4];
    _line4.backgroundColor = [UIColor colorWithHexString:@"#FE8A52"];
    [_line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.richBoxItem5View.mas_right).offset(0);
        make.right.equalTo(self.richBoxItem4View.mas_left).offset(0);
        make.height.equalTo(@(lineHeight));
        make.centerY.equalTo(self.richBoxItem4View);
    }];
    

    //box6
    _richBoxItem6View = [[RichBoxItemView alloc]initWithFrame:CGRectZero];
    _richBoxItem6View.selectItemBlock = ^(id  _Nonnull model) {
         [weakSelf exchangePrizeGift:model];
    };
    [scrollContentView addSubview:_richBoxItem6View];
    [_richBoxItem6View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.equalTo(self.richBoxItem1View.mas_bottom).offset(20);
        make.size.equalTo(@(CGSizeMake(boxWidth, boxHeight)));
    }];
    
    
    _line5 = [[UIView alloc]init];
    [scrollContentView addSubview:_line5];
    _line5.backgroundColor = [UIColor colorWithHexString:@"#FC6C6B"];
    [_line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.richBoxItem6View.mas_right).offset(0);
        make.right.equalTo(self.richBoxItem5View.mas_left).offset(0);
        make.height.equalTo(@(lineHeight));
        make.centerY.equalTo(self.richBoxItem5View);
    }];
    

    //box7
    _richBoxItem7View = [[RichBoxItemView alloc]initWithFrame:CGRectZero];
    _richBoxItem7View.selectItemBlock = ^(id  _Nonnull model) {
         [weakSelf exchangePrizeGift:model];
    };
    [scrollContentView addSubview:_richBoxItem7View];
    [_richBoxItem7View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.richBoxItem6View.mas_left);
        make.top.equalTo(self.richBoxItem6View.mas_bottom).offset(20);
        make.size.equalTo(@(CGSizeMake(120, 140)));
    }];
    
    _line6 = [[UIView alloc]init];
    [scrollContentView addSubview:_line6];
    _line6.backgroundColor = [UIColor colorWithHexString:@"#FC6C6B"];
    [_line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.richBoxItem6View.mas_bottom).offset(0);
        make.bottom.equalTo(self.richBoxItem7View.mas_top).offset(0);
        make.width.equalTo(@(lineHeight));
        make.centerX.equalTo(self.richBoxItem6View);
    }];
    
    
    //box8
    _richBoxItem8View = [[RichBoxItemView alloc]initWithFrame:CGRectZero];
    _richBoxItem8View.selectItemBlock = ^(id  _Nonnull model) {
         [weakSelf exchangePrizeGift:model];
    };
    [scrollContentView addSubview:_richBoxItem8View];
    [_richBoxItem8View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.richBoxItem4View.mas_right);
        make.top.equalTo(self.richBoxItem7View);
        make.size.equalTo(@(CGSizeMake(120, 140)));
        make.bottom.mas_equalTo(-20);
    }];
    
    _line7 = [[UIView alloc]init];
    [scrollContentView addSubview:_line7];
    _line7.backgroundColor = [UIColor colorWithHexString:@"#FE7B5F"];
    [_line7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.richBoxItem7View.mas_right).offset(0);
        make.right.equalTo(self.richBoxItem8View.mas_left).offset(0);
        make.height.equalTo(@(lineHeight));
        make.centerY.equalTo(self.richBoxItem7View);
    }];
    
    [self defaultHiddenAllView];
    
    [self requestGiftList];
}

-(void)defaultHiddenAllView
{
    _richBoxItem1View.hidden = YES;
    _richBoxItem2View.hidden = YES;
    _richBoxItem3View.hidden = YES;
    _richBoxItem4View.hidden = YES;
    _richBoxItem5View.hidden = YES;
    _richBoxItem6View.hidden = YES;
    _richBoxItem7View.hidden = YES;
    _richBoxItem8View.hidden = YES;
    
    _line1.hidden = YES;
    _line2.hidden = YES;
    _line3.hidden = YES;
    _line4.hidden = YES;
    _line5.hidden = YES;
    _line6.hidden = YES;
    _line7.hidden = YES;
}

//兑换礼物；
-(void)exchangePrizeGift:(id)model
{
    RichBoxGift *gift = model;
    //星星足够，并且未兑换过 才可以进行兑换；
    if(gift.needStar <= self.myStartNum && !gift.hasExchanged){
        _popView = [HXQPrizePopView new];
        [_popView showWithModel:gift];
        __weak typeof(self) weakself = self;
        _popView.popShareBlock = ^{
            [weakself requestExchangeGift:gift];
        };
    }else{
        if(gift.hasExchanged){
            [MBProgressHUD showMessage:@"奖励已领取"];
        }else{
            [MBProgressHUD showMessage:[NSString stringWithFormat:@"还差 %ld 颗星即可领取， 快去抽奖吧",gift.needStar - self.myStartNum]];
        }
    }
}

//兑换
-(void)requestExchangeGift:(RichBoxGift *)gift
{
    if(gift){
        [MBProgressHUD showLoading:@"处理中"];
        PrizeExchangeRichBoxRequest *request = [[PrizeExchangeRichBoxRequest alloc]init];
        request.delegate = self;
        request.treasureBoxId = gift.treasureBoxId;
        [[GYNetworkingManager shareInstance] executeRequest:request];
    }
}

-(void)requestGiftList{
    PrizeRichBoxListRequest *request = [[PrizeRichBoxListRequest alloc]init];
    request.delegate = self;
    [[GYNetworkingManager shareInstance] executeRequest:request];
}

-(void)onRequestStatusError:(BaseResponse *)response
{
    [MBProgressHUD hideHUDForView:nil];
    [MBProgressHUD showError:response.remsg];
}

-(void)onRequestSuccess:(BaseResponse *)response
{
    [MBProgressHUD hideHUDForView:nil];
    if(response.requestAPICode == Http_Prize_RichBoxsList || response.requestAPICode == Http_Prize_ExchangeGift){
        
        if(response.requestAPICode == Http_Prize_ExchangeGift){
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_PrizeMoneyRelaod object:nil];
            [MBProgressHUD showMessage:@"兑换成功"];
             [_popView dismiss];
        }
        
         NSInteger startCount = [[response.dataDic objectForKey:@"starCount"] integerValue];
        self.myStartNum = startCount;
         NSArray *arrList =[response.dataDic objectForKey:@"treasureBoxs"];
         NSArray *modelList = [RichBoxGift mj_objectArrayWithKeyValuesArray:arrList];
        for(NSInteger index = 0; index < modelList.count; index ++){
            
            RichBoxGift *model = modelList[index];
            switch (index) {
                case 0:
                {
                    _line1.hidden = NO;
                    _richBoxItem1View.hidden = NO;
                    [_richBoxItem1View fillGiftModel:model PositionIndex:index startCount:startCount];
                    if(startCount < model.needStar){
                        _line1.backgroundColor = [UIColor colorWithHexString:@"#929292"];
                    }
                    break;
                }
                case 1:
                {
                     _line2.hidden = NO;
                    _richBoxItem2View.hidden = NO;
                    [_richBoxItem2View  fillGiftModel:model PositionIndex:index startCount:startCount];
                    if(startCount < model.needStar){
                        _line2.backgroundColor = [UIColor colorWithHexString:@"#929292"];
                    }
                    break;
                }
                case 2:
                {
                    _line3.hidden = NO;
                    _richBoxItem3View.hidden = NO;
                    [_richBoxItem3View fillGiftModel:model PositionIndex:index startCount:startCount];
                    if(startCount < model.needStar){
                        _line3.backgroundColor = [UIColor colorWithHexString:@"#929292"];
                    }
                    break;
                }
                case 3:
                {
                     _line4.hidden = NO;
                    _richBoxItem4View.hidden = NO;
                    [_richBoxItem4View fillGiftModel:model PositionIndex:index startCount:startCount];
                    if(startCount < model.needStar){
                        _line4.backgroundColor = [UIColor colorWithHexString:@"#929292"];
                    }
                    break;
                }
                case 4:
                {
                     _line5.hidden = NO;
                     _richBoxItem5View.hidden = NO;
                    [_richBoxItem5View fillGiftModel:model PositionIndex:index startCount:startCount];
                    if(startCount < model.needStar){
                        _line5.backgroundColor = [UIColor colorWithHexString:@"#929292"];
                    }
                    break;
                }
                case 5:
                {
                    _line6.hidden = NO;
                    _richBoxItem6View.hidden = NO;
                    [_richBoxItem6View fillGiftModel:model PositionIndex:index startCount:startCount];
                    if(startCount < model.needStar){
                        _line6.backgroundColor = [UIColor colorWithHexString:@"#929292"];
                    }
                    break;
                }
                case 6:
                {
                    _line7.hidden = NO;
                    _richBoxItem7View.hidden = NO;
                    [_richBoxItem7View fillGiftModel:model PositionIndex:index startCount:startCount];
                    if(startCount < model.needStar){
                        _line7.backgroundColor = [UIColor colorWithHexString:@"#929292"];
                    }
                    break;
                }
                case 7:
                {
                    _richBoxItem8View.hidden = NO;
                    [_richBoxItem8View fillGiftModel:model PositionIndex:index startCount:startCount];
                    break;
                }
                default:
                    break;
            }
        }
        
    }
}

#pragma mark response

- (void)doneAction:(UIButton *)sender {
    
    [self hide];
}

- (void)hide{
    
    [UIView animateWithDuration:0.22
                     animations:^{
                        
                        self.containerView.frame = CGRectMake(0, self.frame.size.height, self.containerView.frame.size.width, self.containerView.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

#pragma mark setter/getter

- (UIButton *)cancelBtn {
    
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.tag = 100;
        [_cancelBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = LJFontRegularText(14);
        [_cancelBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hide];
}

@end
