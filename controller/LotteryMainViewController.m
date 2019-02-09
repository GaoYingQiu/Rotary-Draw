//
//  LotteryMainViewController.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/9.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "LotteryMainViewController.h"
#import "YJWebVC.h"
#import "PrizeTypeSelectView.h"
#import "JoJoScrollView.h"
#import "LotteryViewController.h"
#import "GYPrizeContairView.h"
#import "YJLoginVC.h"

@interface LotteryMainViewController()
@property (nonatomic, strong) UIButton * leftNavBtn; //余额控制；
@property(nonatomic,strong) JoJoScrollView *scrollView; //

@property(nonatomic,strong) LotteryViewController *happayPrizeVC; //欢乐转盘
@property(nonatomic,strong) LotteryViewController *goldPrizeVC; //黄金转盘

@property(nonatomic,assign) DrawPrizeType drawType;
@end

@implementation LotteryMainViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"抽奖";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPrizeMoney) name:Notification_PrizeMoneyRelaod object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(whenPrizeReloadPrizeMoney:) name:Notification_WhenPrizeMoneyRelaod object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPrizeMoney) name:Notification_LoginStateChange object:nil];
    
    
    
    self.drawType = DrawPrize_Happy;
    //视图；
    [self createNavView];
    //转盘类型选择
    MJWeakSelf
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 56)];
    [self.view addSubview:headerView];
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_prize_bg"]];
    [headerView addSubview:backImageView];
    backImageView.layer.opacity = 0.25;
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView);
    }];
    
    PrizeTypeSelectView *selectView = [[PrizeTypeSelectView alloc]initWithFrame:CGRectMake(15, 10, SCREEN_W-30, 36)];
    [selectView defaultChoosePrizeType:self.drawType];
    selectView.selectBlock = ^(DrawPrizeType type) {
        //根据选择的类型 切换转盘；
        weakSelf.drawType  = type;
        if(type == DrawPrize_Happy){
            [weakSelf selectHapplyPrizeVC];
        }else{
            [weakSelf selectGoldPrizeVC];
        }
    };
    selectView.bCanSelectFlagBlock = ^BOOL{
        if(weakSelf.drawType == DrawPrize_Happy){
            return weakSelf.happayPrizeVC.showAnimationing;
        }else{
             return weakSelf.goldPrizeVC.showAnimationing;
        }
    };
    [headerView addSubview:selectView];
    
    [self createSrollView];
    [self createFooterToolView];
    [self selectHapplyPrizeVC]; //选中欢乐转盘；
    
    //请求金额
    [self requestAccount];
}

-(BOOL)fd_interactivePopDisabled{
    return YES;
}

#pragma mark - Notification
-(void)reloadPrizeMoney
{
    if([GYLoginManager shareInstance].isLogin){
         [self requestAccount];
    }
}


-(void)requestAccount{
    
    if([GYLoginManager shareInstance].isLogin){
        GameAccountRequest *request =  [[GameAccountRequest alloc]init];
        request.delegate = self;
        request.tranBackAllMoneyFlag = NO;
        [[GYNetworkingManager shareInstance] executeRequest:request];
    }else{
        [self.leftNavBtn setImage:nil forState:0];
        [self.leftNavBtn setTitle:@" 登录" forState:0];
        self.leftNavBtn.backgroundColor = [UIColor clearColor];
        self.leftNavBtn.titleLabel.font = LJFontRegularText(16);
    }
}

-(void)whenPrizeReloadPrizeMoney:(NSNotification *)notify
{
//    [self requestAccount];
    
    NSString *totalStr = notify.object;
    if(totalStr){
         self.totalMoneyStr = totalStr;
        [self.leftNavBtn setTitle:[NSString stringWithFormat:@"  ¥ %.3lf",totalStr.floatValue] forState:0];
    }
}

-(void)onRequestSuccess:(BaseResponse *)response
{
    if(response.requestAPICode == Http_GameApi_Account){
        
        [MBProgressHUD hideHUDForView:nil];
        //账号余额；
        if([response.requestObject integerValue] == 1){
            [MBProgressHUD showMessage:@"提取成功"];
        }
        NSString *totalStr = [response.responseObject objectForKey:@"totalMoney"];
        self.totalMoneyStr = totalStr;
        self.centerMoneyStr = [response.responseObject objectForKey:@"safeMoney"];
        
        [self.leftNavBtn setImage:[UIImage imageNamed:@"ic_nav_list"] forState:0];
        [self.leftNavBtn setTitle:[NSString stringWithFormat:@"  ¥ %.3lf",totalStr.floatValue] forState:0];
        self.leftNavBtn.backgroundColor = LJBlackColor2;
        self.leftNavBtn.titleLabel.font = LJFontMoneyText(16);
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -14;
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftNavBtn];
        self.navigationItem.leftBarButtonItems = @[negativeSpacer,leftItem];
        
        self.apiMenuArr = [response.responseObject objectForKey:@"gameAccountList"];
        self.filterView.money = self.totalMoneyStr;
        self.filterView.centerMoney = self.centerMoneyStr;
        self.filterView.datas = self.apiMenuArr;
    }
}

-(void)createFooterToolView
{
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.equalTo(@49);
    }];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_prize_bg"]];
    [footerView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerView);
    }];
    
    UIImageView *icon1 = [[UIImageView alloc]init];
    icon1.image = [UIImage imageNamed:@"ic_nav_back"];
    [footerView addSubview:icon1];
    [icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(37);
        make.top.mas_equalTo(9);
        make.width.height.equalTo(@20);
    }];
    
    UILabel *desc1Label = [[UILabel alloc]init];
    [footerView addSubview:desc1Label];
    desc1Label.text = @"返回";
    desc1Label.font = LJFontRegularText(10);
    desc1Label.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    [desc1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon1.mas_bottom).offset(5);
        make.centerX.equalTo(icon1);
    }];
    
    UIButton *coverbtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:coverbtn1];
    [coverbtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(icon1.mas_centerX);
        make.centerY.mas_equalTo(footerView);
        make.height.width.equalTo(@44);
    }];
    
    
    UIImageView *icon2 = [[UIImageView alloc]init];
     [footerView addSubview:icon2];
    icon2.image = [UIImage imageNamed:@"ic_tab_game"];
    [icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footerView);
        make.top.mas_equalTo(9);
        make.width.height.equalTo(@20);
    }];
    
    UILabel *desc2Label = [[UILabel alloc]init];
    [footerView addSubview:desc2Label];
    desc2Label.text = @"玩法";
    desc2Label.font = LJFontRegularText(10);
    desc2Label.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    [desc2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon2.mas_bottom).offset(5);
        make.centerX.equalTo(icon2);
    }];
    
    UIButton *coverbtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:coverbtn2];
    [coverbtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(icon2.mas_centerX);
        make.centerY.mas_equalTo(footerView);
        make.height.width.equalTo(@44);
    }];
    
    
    
    UIImageView *icon3 = [[UIImageView alloc]init];
     [footerView addSubview:icon3];
    icon3.image = [UIImage imageNamed:@"ic_tab_note"];
    [icon3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-37);
        make.top.mas_equalTo(9);
        make.width.height.equalTo(@20);
    }];
    
    UILabel *desc3Label = [[UILabel alloc]init];
    [footerView addSubview:desc3Label];
    desc3Label.text = @"记录";
    desc3Label.font = LJFontRegularText(10);
    desc3Label.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    [desc3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon3.mas_bottom).offset(5);
        make.centerX.equalTo(icon3);
    }];
    
    UIButton *coverbtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:coverbtn3];
    [coverbtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(icon3.mas_centerX);
        make.centerY.mas_equalTo(footerView);
        make.height.width.equalTo(@44);
    }];
    
    coverbtn1.tag = 1000;
    coverbtn2.tag = 2000;
    coverbtn3.tag = 3000;
    [coverbtn1 addTarget:self action:@selector(clickFootTollItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [coverbtn2 addTarget:self action:@selector(clickFootTollItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [coverbtn3 addTarget:self action:@selector(clickFootTollItemAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickFootTollItemAction:(UIButton *)sender
{
    if(sender.tag == 1000){
        [self.navigationController popViewControllerAnimated: YES];
    }else if(sender.tag == 2000){
        GYPrizeContairView *sheetView = [[GYPrizeContairView alloc]initSheetStyle:Prize_PlayDesc  actionBlock:^(id selectedData) {
            
        }];
        [sheetView showInView];
    }else{
        
        if([GYLoginManager shareInstance].isLogin){
            GYPrizeContairView *sheetView = [[GYPrizeContairView alloc]initSheetStyle:Prize_Record  actionBlock:^(id selectedData) {
                
            }];
            [sheetView fetch_Record_DefaultChooseSelect:_drawType];
            [sheetView showInView];
        }else{
            YJLoginVC *vc = [[YJLoginVC alloc] init];
            vc.block = ^{
                
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)createNavView
{
    //左边
    _leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if(![GYLoginManager shareInstance].isLogin){
        [_leftNavBtn setTitle:@"登录" forState:0];
    }
    [self.leftNavBtn setImage:[UIImage imageNamed:@"ic_nav_list"] forState:0];
    _leftNavBtn.titleLabel.font = LJFontRegularText(16);
    _leftNavBtn.backgroundColor = [UIColor clearColor];
    _leftNavBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_leftNavBtn addTarget:self action:@selector(openLeftViewAction) forControlEvents:UIControlEventTouchUpInside];
    _leftNavBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [_leftNavBtn setTitleColor:LJYellowColor forState:0];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -14;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:_leftNavBtn];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,leftItem];
    
#ifdef __IPHONE_9_0
    if ([_leftNavBtn respondsToSelector:@selector(widthAnchor)]) {
        [_leftNavBtn.widthAnchor constraintGreaterThanOrEqualToConstant:90].active = YES; //75
        [_leftNavBtn.heightAnchor constraintEqualToConstant:33].active = YES;
    }
#endif
    
    UIImage *rightImage = [[UIImage imageNamed:@"ic_nav_service"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(goKefuPageAction)];
}

-(void)goKefuPageAction
{
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"App_Kefu"];
    YJWebVC *vc = [[YJWebVC alloc]init];
    vc.bNeedCloseFlag = YES;
    vc.url = url;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)createSrollView{
    self.scrollView = [[JoJoScrollView alloc]init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.backgroundColor = LJBackgroundColor;
    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.contentSize = CGSizeMake(SCREEN_W*2, SCREEN_H-46);
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(56);
        make.bottom.mas_equalTo(-49);
    }];
    
    UIView *lastSubView = nil;
    for (int i=0; i< 2; i++) {
        UIView *subView = [[UIView alloc]init];
        subView.backgroundColor = LJBackgroundColor;
        [self.scrollView addSubview:subView];
        subView.tag = 1000+i;
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.equalTo(@(SCREEN_W));
            if(lastSubView){
                make.left.equalTo(lastSubView.mas_right).offset(0);
            }else{
                make.left.mas_equalTo(0);
            }
            if(i == 1){
                make.right.mas_equalTo(0);
            }
        }];
        lastSubView = subView;
    }
}

-(void)selectGoldPrizeVC
{
    if(_goldPrizeVC == nil){
        _goldPrizeVC = [[LotteryViewController alloc] init];
        _goldPrizeVC.currentDrawType = DrawPrize_Gold;
        [self addChildViewController:_goldPrizeVC];
        
        UIView *view = [self.scrollView viewWithTag:1001];
        [view addSubview:_goldPrizeVC.view];
        
        CGFloat subContentH = SCREEN_H - 56 - 49 - (LNavBarHeight+LStatusBarHeight);
        [_goldPrizeVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.equalTo(@(subContentH));
        }];
    }
    self.scrollView.contentOffset = CGPointMake(SCREEN_W , 0);
}

-(void)selectHapplyPrizeVC
{
    if(_happayPrizeVC == nil){
        _happayPrizeVC = [[LotteryViewController alloc] init];
        _happayPrizeVC.currentDrawType = DrawPrize_Happy;
        [self addChildViewController:_happayPrizeVC];
        
        UIView *view = [self.scrollView viewWithTag:1000];
        [view addSubview:_happayPrizeVC.view];
        
        CGFloat subContentH = SCREEN_H - 56 - 49- (LNavBarHeight+LStatusBarHeight);
        [_happayPrizeVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.equalTo(@(subContentH));
        }];
    }
     self.scrollView.contentOffset = CGPointMake(0 , 0);
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
