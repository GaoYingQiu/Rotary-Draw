//
//  LotteryViewController.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/3.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "LotteryViewController.h"
#import "ILDScreenshotImageManager.h"
#import "ILDDiligenceClockView.h"
#import "DiligenceClockView.h"
#import "TYRotaryView.h"
#import "HXQActivityPrizeModel.h"
#import "PrizeListRequest.h"
#import "ZMJTipView.h"
#import "GYPrizeContairView.h"
#import "PrizeRankTableView.h"
#import "PrizePlayRequest.h"
#import "UserPrizeInfoCyclePlayView.h"
#import "GYPrizeRichBoxView.h"
#import "PrizeHotPlayRequest.h"
#import "PrizePopsMsgListRequest.h"
#import "UIView+AnimationProperty.h"
#import "ZYQLikeBtn.h"
#import "YJLoginVC.h"


@interface LotteryViewController ()<ILDDiligenceClockViewDelegate,DiligenceClockViewDelegate,PrizeRankTableViewDelegate>
@property(nonatomic, strong) ILDDiligenceClockView *diligenceClockView;
@property(nonatomic, strong) DiligenceClockView *clockView;
@property(nonatomic, assign) BOOL isRestMode;
@property(nonatomic, strong) NSDate *startDate; //暴走值满后，触发开始倒计时 的打点时间；（暴走值满的时间；）
@property(nonatomic, assign) NSInteger currentPlayTimeType; //连抽状态；1 ， 10 ， 30
@property (nonatomic, strong) TYRotaryView *rotaryView; //转盘

@property (nonatomic, strong) UIView *hotDoublePrizeView; //暴击模式view
@property (nonatomic, strong) UIView *richBoxView; //宝箱view
@property (nonatomic, strong) UIView *skillView; //元宝技能

@property (nonatomic, strong) ZYQLikeBtn *showStartBtn;

@property (nonatomic, strong) UIImageView  *iconLeft1;
@property (nonatomic, strong) UIImageView  *iconLeft2;

@property (nonatomic, strong) UIButton * tenSkillBtn; //十连抽
@property (nonatomic, strong) UIButton * thirtySkillBtn; //三十连抽

@property (nonatomic, strong) HXQActivityPrizeModel *currentPrizeModel;  //当前奖品

@property (nonatomic, strong) NSMutableArray *prizeList; //奖品列表；

@property (nonatomic, strong) PrizeListRequest *prizeListRequest; //请求奖品列表

@property (nonatomic, assign) BOOL burningFlag; //黄金转盘：是否在燃烧状态；
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, strong) PrizePlayModel * serverPrizeModel; //服务端返回奖品
@property (nonatomic, strong) PrizeHotModel * hotCritModel; //暴击值；

@property (nonatomic, strong)  UILabel  *doubleSkillDescLabel; //显示一次转盘花费钱；

@property (nonatomic, strong) NSArray *tanMuArr; //弹幕
@property (nonatomic, strong) UserPrizeInfoCyclePlayView *tanMuview;
@property(nonatomic,strong) NSTimer *danMuTimer;
@property(nonatomic,assign) BOOL topPositionFlag; //弹幕 第一行，第二行；

@end

@implementation LotteryViewController
@synthesize iconLeft1,iconLeft2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"抽奖";
    
    _currentPlayTimeType = 1; //单抽
    _prizeListRequest = [[PrizeListRequest alloc]init];
    _prizeListRequest.delegate = self;
    
    //通知；
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterBackground:)name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification:)name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    _scrollContentView = [[UIView alloc]init];
    [scrollView addSubview:_scrollContentView];
    [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.equalTo(@(SCREEN_W));
    }];
    
    
    [_scrollContentView addSubview:self.tanMuview]; //弹幕
    [_scrollContentView addSubview:self.diligenceClockView]; //暴击
    [_scrollContentView addSubview:self.clockView]; //倒计时；
    [_scrollContentView addSubview:self.rotaryView]; //在最表面；
    [self createHotDoublePrizeView]; //暴击模式
    [self createRichBoxView]; //宝箱
    [self createSkillView]; //技能
    [self createSkllBtns]; //连抽按钮
    [self createRankingView]; //排名
    
    //设置抽奖转盘的地盘样式；
    [self refreshRotaryViewStyle];
    
    //请求奖品列表；
    [self requestPrizeList];

    [self requetCritValue]; //首次获取暴击值
    [self.diligenceClockView startTimer]; //启动请求暴击值定时器
    
    [self requestDanMuList]; //请求弹幕
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self fireTimerClock];
}

-(void)fireTimerClock{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopDanMuTimer];
    [self stopDiligenceClock];
    [self stopClockTimer];
}

-(void)dealloc{
    [self fireTimerClock];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tanMuview.frame = CGRectMake(0, 0, SCREEN_W, 55);
    
    [self.rotaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(50);
        make.right.mas_offset(-50);
        make.top.mas_equalTo(65);
        make.height.mas_equalTo(self.rotaryView.mas_width);
    }];
    
    [self.diligenceClockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.rotaryView);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(self.diligenceClockView.mas_width);
    }];
    
    [self.clockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.diligenceClockView);
    }];
}



#pragma mark - Net Request
//请求弹幕
-(void)requestDanMuList{
    
    PrizePopsMsgListRequest *request = [[PrizePopsMsgListRequest alloc]init];
    request.delegate = self;
    [[GYNetworkingManager shareInstance] executeRequest:request];
}

//请求暴击值；
-(void)requetCritValue
{
    PrizeHotPlayRequest *request = [[PrizeHotPlayRequest alloc]init];
    request.delegate = self;
    request.drawPrizeType = self.currentDrawType;
    [[GYNetworkingManager shareInstance] executeRequest:request];
}

//请求转盘礼品
-(void)requestPrizeList
{
    _prizeListRequest.drawPrizeType = self.currentDrawType;
    [[GYNetworkingManager shareInstance] executeRequest:_prizeListRequest];
}

//开始抽奖
-(void)requestStartPrize
{
    //发起网络请求获取当前选中奖品
    PrizePlayRequest *request = [[PrizePlayRequest alloc]init];
    request.delegate = self;
    request.drawPrizeType = self.currentDrawType;
    request.playTimeType = self.currentPlayTimeType;
    [[GYNetworkingManager shareInstance] executeRequest:request];
}

-(void)onRequestSuccess:(BaseResponse *)response
{
    if(response.requestAPICode == Http_Prize_List){
        
        [self.prizeList removeAllObjects];
        NSArray *arr = response.responseObject;
        if([arr isKindOfClass:[NSArray class]]){
            [self.prizeList addObjectsFromArray:arr];
        }
        
        [self.rotaryView lotteryDrawPrizeType:self.currentDrawType prizeList:self.prizeList];
    }else if(response.requestAPICode == Http_Prize_Play){
        self.serverPrizeModel = response.responseObject;
        self.showStartBtn.selected = YES; //飘动星星；
        [self starToLottery];
        
    }else if(response.requestAPICode == Http_Prize_CritValue){
        
        self.hotCritModel = response.responseObject; //设置当前的暴击值；
        
    }else if(response.requestAPICode == Http_Prize_PopsList){
        _tanMuArr = response.responseObject;
        
        [self.tanMuview addTimer]; //弹幕刷新；
        [self startDanMuTimer]; //每2秒产生一条弹幕消息
    }
}

-(void)onRequestError:(NSError *)error request:(BaseDataRequest *)request
{
    
}

-(void)onRequestStatusError:(BaseResponse *)response
{
    [MBProgressHUD hideHUDForView:nil];
    [MBProgressHUD showError:response.remsg];
}


#pragma mark - 启动弹幕
- (void)startDanMuTimer {
    if (!self.danMuTimer) {
        self.danMuTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(startPlayDanMuMessage) userInfo:nil repeats:YES];
    }
}

-(void)startPlayDanMuMessage
{
    _topPositionFlag = !_topPositionFlag; //切换位置；
    
    // 获得一个随机整数
    NSInteger index = arc4random_uniform((u_int32_t)self.tanMuArr.count);
    // 获得一个随机模型
    NSString *danMu = self.tanMuArr[index];
    // 根据模型生成图片
    GYImage *image = [self.tanMuview imageWithBarrage:danMu];
    // 调整弹幕加载区域
    image.x = self.view.bounds.size.width;
    
    NSArray *yPosition_arr = @[@5,@30];
    image.y = [(yPosition_arr[self.topPositionFlag?0:1]) floatValue];
    // 把图片加到弹幕view上
    [self.tanMuview addImage:image];
    
}

- (void)stopDanMuTimer {
    [self.danMuTimer invalidate];
}


#pragma mark -  Layout Refresh
//刷新转盘样式；
-(void)refreshRotaryViewStyle{
    
    _hotDoublePrizeView.hidden = !self.burningFlag;
    if(_currentDrawType == DrawPrize_Happy){
        _skillView.hidden = YES;
        _richBoxView.hidden = YES;
        [self.rotaryView lotteryRotaryLevel:Rotary_Level_Happly];
    }else{
        _skillView.hidden = NO;
        _richBoxView.hidden = NO;
        if(_burningFlag){
            [self.rotaryView lotteryRotaryLevel:Rotary_Level_Gold]; //燃烧状态；
        }else{
            [self.rotaryView lotteryRotaryLevel:Rotary_Level_Crit];
        }
    }
    
    if(_burningFlag){
        _doubleSkillDescLabel.text = @"暴击模式,转动一次转盘，中奖率翻倍";
    }
}

#pragma mark- 抽奖 与 转盘停止
-(void)starToLottery{
    //判断余额是否足够；
    self.showAnimationing = YES;
    
    //禁用按钮
    //self.rotaryView.startButton.userInteractionEnabled = NO;
    NSInteger prizeIndex = -1;
    //拿到当前奖品的 找到其对于的位置
    for (NSInteger i=0;i < self.prizeList.count; i++) {
        HXQActivityPrizeModel *prize = [self.prizeList objectAtIndex:i];
        if(prize.prizeId == self.serverPrizeModel.prizeId){
            prizeIndex = i;
            self.currentPrizeModel = [self.prizeList objectAtIndex:i];
            break;
        }
    }
    
    //找到中奖奖品才进行；
    if(prizeIndex > -1){
        
        //让转盘转起来
        [self.rotaryView animationWithSelectonIndex:prizeIndex];
    }
}

-(void)handleEndRollAction{
    
    //抽奖结束 弹出奖品
    GYPrizeContairView *sheetView = [[GYPrizeContairView alloc]initSheetStyle:Prize_Gift  actionBlock:^(id selectedData) {
        
    }];
    [sheetView fetch_Prize_Gift:self.serverPrizeModel.prizeList];
    [sheetView showInView];
}

#pragma mark - Notifications / KVOs

- (void)applicationWillEnterBackground:(NSNotification *)notification {
    
    [self.clockView stopTimer]; //暂停倒计时；
    [self.diligenceClockView pauseTimer]; //每隔3秒刷新 的定时器停止；
}

-(void)appWillEnterForegroundNotification:(NSNotification *)notification {
    
    NSLog(@"从后台恢复");
    [self reStartCheckServerTimer];
    //App 恢复的时候 或在 重新打开游戏界面的时候： 请求拿到 暴走值满的时间时间戳startDate， 当前时间 - startDate 为进度时间，如果进度时间大于180 ，则归零倒计时； 如果小于180 设置进度（设置剩余的时间，刷新；）；
    
    //暴走值 每隔3秒请求一次，；
}

//跳转更多排名；
#pragma mark - PrizeRankTableViewDelegate
-(void)goLookMoreRankingPage
{
    GYPrizeContairView *sheetView = [[GYPrizeContairView alloc]initSheetStyle:Prize_Ranking  actionBlock:^(id selectedData) {
        
    }];
    [sheetView fetch_Ranking_DrawType:self.currentDrawType];
    [sheetView showInView];
}

#pragma mark - ILDDiligenceClockViewDelegate  倒计时 和 暴击值满时候委托调用；
- (void)taskCompleted
{
    _burningFlag = YES;
    if(!self.clockView.isRunning){
        //暴击值满 ，启动倒计时
        [self startDiligenceClockTime];
    }
    [self refreshRotaryViewStyle];
}

 //倒计时定时器走完，暴走值归零；
- (void)taskClockCompleted
{
   _burningFlag = NO;
  [self.diligenceClockView setIsRestMode:YES];
  
  [self refreshRotaryViewStyle];
    
  [self reStartCheckServerTimer];
}

-(void)reStartCheckServerTimer
{
    //1、启动定时，拿到最新的暴走值；
    [self.diligenceClockView resumeTimer];
}

//拷贝屏幕；
- (void)copyScreen {
   
    CGRect rect = self.view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *screenview = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    ILDScreenshotImageManager *screenshotImageManager = [ILDScreenshotImageManager sharedInstance];
    screenshotImageManager.screenshotImage = screenview;
}


#pragma mark - public method
//开启倒计时；
- (void)startDiligenceClockTime {
   
    [self.clockView setDiligenceSeconds:180];
    [self.clockView fill_LeftTimeValue:self.hotCritModel.remainingTime];
    [self.clockView startTimer];
}


- (void)pauseDiligenceClock {
    [self.diligenceClockView pauseTimer];
}

- (void)resumeDiligenceClock {
    [self.diligenceClockView resumeTimer];
}

- (void)stopDiligenceClock {
    [self.diligenceClockView stopTimer];
}

-(void)stopClockTimer
{
    [self.clockView stopTimer];
}

#pragma mark - User Actions
-(void)showRichBoxAction:(UIButton *)btn{
    
    if([GYLoginManager shareInstance].isLogin){
        GYPrizeRichBoxView * richBoxView = [[GYPrizeRichBoxView alloc]initSheetRichBox];
        [richBoxView showInView];
    }else{
        YJLoginVC *vc = [[YJLoginVC alloc] init];
        vc.block = ^{
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)showSkillDescAction{
    
    if([GYLoginManager shareInstance].isLogin){
        GYPrizeContairView *sheetView = [[GYPrizeContairView alloc]initSheetStyle:Prize_SkillDesc  actionBlock:^(id selectedData) {
            
        }];
        [sheetView showInView];
    }else{
        YJLoginVC *vc = [[YJLoginVC alloc] init];
        vc.block = ^{
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)clickTipShowAction:(UIButton *)sender
{
    if(sender.tag == 1000){
        _tenSkillBtn.selected = !_tenSkillBtn.selected;
        if(_tenSkillBtn.selected){
            iconLeft1.image = [UIImage imageNamed:@"ic_coupon_nor"];
            iconLeft2.image = [UIImage imageNamed:@"ic_coupon_uls"];
            _thirtySkillBtn.selected = NO;
        }else{
            iconLeft2.image = [UIImage imageNamed:@"ic_coupon_nor"];
            iconLeft1.image = [UIImage imageNamed:@"ic_coupon_uls"];
        }
    }else{
        _thirtySkillBtn.selected = !_thirtySkillBtn.selected;
        if(_thirtySkillBtn.selected){
            _tenSkillBtn.selected = NO;
            iconLeft1.image = [UIImage imageNamed:@"ic_coupon_uls"];
            iconLeft2.image = [UIImage imageNamed:@"ic_coupon_nor"];
        }else{
            iconLeft1.image = [UIImage imageNamed:@"ic_coupon_nor"];
            iconLeft2.image = [UIImage imageNamed:@"ic_coupon_uls"];
        }
    }
    
    self.currentPlayTimeType = 1;
    
    if(_tenSkillBtn.selected){
        self.currentPlayTimeType = 10;
    }else if(_thirtySkillBtn.selected){
         self.currentPlayTimeType = 30;
    }
    
    NSInteger money = (self.currentDrawType == DrawPrize_Happy?1:100) * self.currentPlayTimeType;
    _doubleSkillDescLabel.text = [NSString stringWithFormat:@"点击开始，转动一次转盘，花费%ld元",money];
    
    //选中情况下 才弹出提示；
    if(self.currentPlayTimeType > 1){
        
        ZMJPreferences *preferences = ZMJTipView.globalPreferences;
        preferences.drawing.backgroundColor = [UIColor whiteColor];
        
        preferences.animating.dismissTransform = CGAffineTransformMakeTranslation(0, -15);
        preferences.animating.showInitialTransform = CGAffineTransformMakeTranslation(0, -15);
        preferences.animating.showInitialAlpha = 0;
        preferences.animating.showDuration = 1.5;
        preferences.drawing.foregroundColor = [UIColor blackColor];
        preferences.animating.dismissDuration = 1.5;
        preferences.drawing.font = LJFontRegularText(11);
        preferences.drawing.arrowPosition = ZMJArrowPosition_bottom;
        preferences.positioning.maxWidth = 230;
        NSString *text = [NSString stringWithFormat:@"花费%ld元，增加%@暴中奖率，+%@点暴击值",money,self.currentPlayTimeType==10?@"10%":@"40%",self.currentPlayTimeType==10?@"11":@"35"];
        [ZMJTipView showAnimated:YES
                         forView:sender
                 withinSuperview:self.scrollContentView
                            text:text
                     preferences:preferences
                        delegate:nil];
    }
}


#pragma mark - Getter and Setter
- (ILDDiligenceClockView *)diligenceClockView {
    if (!_diligenceClockView) {
        _diligenceClockView = [[ILDDiligenceClockView alloc] init];
        _diligenceClockView.taskName = @"暴击值";
        _diligenceClockView.delegate = self;
        MJWeakSelf
        _diligenceClockView.requestCritValueBlock = ^{
            [weakSelf requetCritValue]; //请求暴走值；
        };
    }
    
    return _diligenceClockView;
}

-(UserPrizeInfoCyclePlayView *)tanMuview
{
    if (!_tanMuview) {
        _tanMuview = [[UserPrizeInfoCyclePlayView alloc] init];
        _tanMuview.backgroundColor = [UIColor clearColor];
    }
    return _tanMuview;
}

- (DiligenceClockView *)clockView {
    if (!_clockView) {
        _clockView = [[DiligenceClockView alloc] init];
        _clockView.taskName = @"倒计时";
        _clockView.delegate = self;
    }
    
    return _clockView;
}

-(TYRotaryView *)rotaryView{
    if(!_rotaryView){
        _rotaryView = [TYRotaryView new];
        __weak typeof(self) weakSelf = self;
        self.rotaryView.rotaryStartTurnBlock = ^{
            
            if([GYLoginManager shareInstance].isLogin){
                [weakSelf requestStartPrize]; //开始抽奖
            }else{
                YJLoginVC *vc = [[YJLoginVC alloc] init];
                vc.block = ^{
                    
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        self.rotaryView.rotaryEndTurnBlock = ^{
            weakSelf.showAnimationing = NO;
            
            //通知去刷新金额；
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_WhenPrizeMoneyRelaod object:weakSelf.serverPrizeModel.totalMoney];
            
            if(weakSelf.serverPrizeModel.bingo){
                //中奖了；
                 [weakSelf handleEndRollAction];
            }else{
                [MBProgressHUD showMessage:@"很遗憾暂未中奖"];
            }
        };
    }
    return _rotaryView;
}

-(void)createSkillView
{
    _skillView = [[UIView alloc]init];
    _skillView.hidden = NO;
    [_scrollContentView addSubview:_skillView];
    
    [_skillView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(self.rotaryView.mas_bottom);
    }];
    
    UIImageView *icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"ic_ingots"];
    [_skillView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@38);
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    
    UILabel  *descLabel = [[UILabel alloc]init];
    [_skillView addSubview:descLabel];
    descLabel.text = @"技能";
    descLabel.font = LJFontRegularText(11);
    descLabel.textColor = [UIColor colorWithWhite:1 alpha:0.3];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom);
        make.centerX.equalTo(icon);
        make.bottom.mas_equalTo(0);
    }];
    
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_skillView addSubview:coverBtn];
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.skillView);
    }];
    [coverBtn addTarget:self action:@selector(showSkillDescAction) forControlEvents:UIControlEventTouchUpInside];
}


-(void)createRankingView
{
    PrizeRankTableView *rankingView = [[PrizeRankTableView alloc]init];
    rankingView.delegate = self;
    rankingView.bNeedHeaderViewFlag = YES;
    rankingView.drawType = self.currentDrawType;
    [self.scrollContentView addSubview:rankingView];
    [rankingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tenSkillBtn.mas_bottom).offset(35);
        make.left.right.mas_equalTo(0);
        make.height.equalTo(@(54*3 + 44)); //5行
        make.bottom.mas_equalTo(0);
    }];
}


-(void)createSkllBtns
{
    _tenSkillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tenSkillBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#5b4331"]] forState:UIControlStateNormal];
    [_tenSkillBtn setBackgroundImage:[UIImage imageNamed:@"liquan_bg_10"] forState:UIControlStateSelected];
    [_tenSkillBtn setTitle:@"十连抽" forState:UIControlStateNormal];
    _tenSkillBtn.titleLabel.font = LJFontRegularText(12);
    [_scrollContentView addSubview:_tenSkillBtn];
    _tenSkillBtn.layer.cornerRadius = 15;
    _tenSkillBtn.tag = 1000;
    [_tenSkillBtn addTarget:self action:@selector(clickTipShowAction:) forControlEvents:UIControlEventTouchUpInside];
    _tenSkillBtn.layer.masksToBounds = YES;
    
    [_tenSkillBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollContentView.mas_centerX).offset(-7.5);
        make.width.equalTo(@93);
        make.height.equalTo(@30);
        make.top.equalTo(self.clockView.mas_bottom).offset(40);
    }];
    
    iconLeft1 = [[UIImageView alloc]init];
    iconLeft1.image = [UIImage imageNamed:@"ic_coupon_uls"];
    [_scrollContentView addSubview:iconLeft1];
    [iconLeft1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@37);
        make.left.equalTo(self.tenSkillBtn.mas_left).offset(-9);
        make.bottom.equalTo(self.tenSkillBtn.mas_bottom);
    }];
    
    
    _thirtySkillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_thirtySkillBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#5b4331"]] forState:UIControlStateNormal];
    [_thirtySkillBtn addTarget:self action:@selector(clickTipShowAction:) forControlEvents:UIControlEventTouchUpInside];
    [_thirtySkillBtn setBackgroundImage:[UIImage imageNamed:@"liquan_bg_30"] forState:UIControlStateSelected];
     _thirtySkillBtn.tag = 2000;
    [_thirtySkillBtn setTitle:@"三十连抽" forState:UIControlStateNormal];
    _thirtySkillBtn.titleLabel.font = LJFontRegularText(12);
    [_scrollContentView addSubview:_thirtySkillBtn];
    _thirtySkillBtn.layer.cornerRadius = 15;
    _thirtySkillBtn.layer.masksToBounds = YES;
    [_thirtySkillBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContentView.mas_centerX).offset(7.5);
        make.width.equalTo(@93);
        make.height.equalTo(@30);
        make.top.equalTo(self.tenSkillBtn);
    }];
    
    iconLeft2 = [[UIImageView alloc]init];
    iconLeft2.image = [UIImage imageNamed:@"ic_coupon_uls"];
    [self.scrollContentView addSubview:iconLeft2];
    [iconLeft2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@37);
        make.left.equalTo(self.thirtySkillBtn.mas_left).offset(-9);
        make.bottom.equalTo(self.thirtySkillBtn.mas_bottom);
    }];
    
    _doubleSkillDescLabel = [[UILabel alloc]init];
    [self.scrollContentView addSubview:_doubleSkillDescLabel];
    if(self.currentDrawType == DrawPrize_Happy){
        _doubleSkillDescLabel.text = @"点击开始，转动一次转盘，花费1元";
    }else{
        _doubleSkillDescLabel.text = @"点击开始，转动一次转盘，花费100元";
    }
    _doubleSkillDescLabel.font = LJFontRegularText(10);
    _doubleSkillDescLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    [_doubleSkillDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tenSkillBtn.mas_bottom).offset(5);
        make.centerX.equalTo(self.view);
    }];
    
}

-(void)createRichBoxView
{
    _richBoxView = [[UIView alloc]init];
    _richBoxView.hidden = NO;
    [_scrollContentView addSubview:_richBoxView];
    
    [_richBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.equalTo(self.rotaryView.mas_bottom);
    }];
    
    UIImageView *icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"ic_treasure chest_1"];
    [_richBoxView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@44);
        make.right.mas_equalTo(-11);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(11);
    }];
    
    UILabel  *descLabel = [[UILabel alloc]init];
    [_richBoxView addSubview:descLabel];
    descLabel.text = @"宝箱";
    descLabel.font = LJFontRegularText(11);
    descLabel.textColor = [UIColor colorWithWhite:1 alpha:0.3];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom);
        make.centerX.equalTo(icon);
        make.bottom.mas_equalTo(0);
    }];
    
    
    
    _showStartBtn = [[ZYQLikeBtn alloc] initWithFrame:CGRectZero];
    if(_currentPlayTimeType == 1){
        _showStartBtn.type = ZYQLikeBtnGhostType; //单抽
    }else{
        _showStartBtn.type = ZYQLikeBtnOverlapType; //连抽
    }
    [_showStartBtn setBackgroundImage:[UIImage imageNamed:@"ic_star"] forState:UIControlStateSelected];
    [_richBoxView insertSubview:_showStartBtn belowSubview:icon];
    [_showStartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(icon);
        make.width.height.equalTo(@20);
    }];
    
    
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_richBoxView addSubview:coverBtn];
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.richBoxView);
    }];
    [coverBtn addTarget:self action:@selector(showRichBoxAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)createHotDoublePrizeView
{
    
    _hotDoublePrizeView = [[UIView alloc]init];
    _hotDoublePrizeView.hidden = YES;
    [_scrollContentView addSubview:_hotDoublePrizeView];
    
    [_hotDoublePrizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.equalTo(self.rotaryView.mas_top);
    }];
    
    UIImageView *icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"ic_crit"];
    [_hotDoublePrizeView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@35);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
    }];
    
    UILabel  *descLabel = [[UILabel alloc]init];
    [_hotDoublePrizeView addSubview:descLabel];
    descLabel.text = @"暴击模式";
    descLabel.font = LJFontRegularText(11);
    descLabel.textColor = [UIColor colorWithHexString:@"#D79B3D"];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom);
        make.centerX.equalTo(icon);
        make.left.mas_equalTo(15);
    }];
    
    UILabel  *desc2Label = [[UILabel alloc]init];
    [_hotDoublePrizeView addSubview:desc2Label];
    desc2Label.font = LJFontRegularText(8);
    desc2Label.text = @"奖金翻倍";
    desc2Label.textColor = [UIColor colorWithWhite:1 alpha:0.3];
    [desc2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom);
        make.centerX.equalTo(icon);
        make.bottom.mas_equalTo(0);
    }];
    
}

-(NSMutableArray *)prizeList{
    if (!_prizeList) {
        _prizeList = [NSMutableArray array];
    }
    return _prizeList;
}

-(void)setCurrentPlayTimeType:(NSInteger)currentPlayTimeType
{
    _currentPlayTimeType = currentPlayTimeType;
    if(_currentPlayTimeType == 1){
        _showStartBtn.type = ZYQLikeBtnGhostType; //单抽
    }else{
        _showStartBtn.type = ZYQLikeBtnOverlapType; //连抽
    }
}

-(void)setHotCritModel:(PrizeHotModel *)hotCritModel
{
    _hotCritModel = hotCritModel;
    _burningFlag = hotCritModel.crit; //是否暴击；
    [self refreshRotaryViewStyle];
    
    //设置暴击值；
    [self.diligenceClockView fill_LeftCritValue:hotCritModel.critValue];
    
    //需设置倒计时；
    if(hotCritModel.crit){
        
        [self startDiligenceClockTime]; //开始倒计时；
    }
}



@end
