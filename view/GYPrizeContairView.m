

#import "GYPrizeContairView.h"
#import "PrizeRankTableView.h"
#import "PrizeGiftTableView.h"
#import "PrizeDescView.h"
#import "PrizePlayDescView.h"
#import "PrizeRecordTableView.h"
#import "ILDScreenshotImageManager.h"
#import "PrizeRecordDetailTableView.h"


@interface GYPrizeContairView ()

@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIView *doneView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) PrizeGiftTableView *giftView;
@property (nonatomic,strong) PrizeRecordTableView *prizeRecordView;
@property (nonatomic,strong) PrizeRecordDetailTableView *prizeDetailRecordView;
@property (nonatomic,strong) PrizeRankTableView *rankingView;
@property (nonatomic,assign) NSInteger selectedIndex; //当前选中的
@property (nonatomic,copy) GYActionDateDoneBlock actionDateDoneBlock;
@property (nonatomic,assign) PrizeStyle sheetCellStyle;
@property(nonatomic,strong) UIImageView *backgroundImageView;
@end

@implementation GYPrizeContairView

- (instancetype)initSheetStyle:(PrizeStyle)prizeStyle actionBlock:(GYActionDateDoneBlock)actionDateDoneBlock{
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
    
        _actionDateDoneBlock = actionDateDoneBlock;
        _sheetCellStyle = prizeStyle;
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
    _doneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
//    _doneView.backgroundColor = [UIColor colorWithHexString:@"#181818"];
//    UIImage *image = [UIImage imageNamed:@"公告栏_切图"];
//    UIImageView *bg = [[UIImageView alloc]initWithImage:image];
//    [_doneView addSubview:bg];
//    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.bottom.top.mas_equalTo(0);
//        make.width.equalTo(@117);
//    }];
    
    [self.containerView addSubview:self.doneView];
    [_doneView addSubview:self.cancelBtn];

    
    self.cancelBtn.backgroundColor = [UIColor clearColor];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.width.height.equalTo(@44);
        make.centerY.mas_equalTo(self.doneView);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = LJFontRegularText(17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [_doneView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.doneView);
    }];
    
    if(_sheetCellStyle == Prize_Ranking){
        [self createRankingView]; //排行榜；
         titleLabel.text =  @"排行榜";
    }else if(_sheetCellStyle == Prize_Gift){
        [self createPrizeGiftView]; //奖品
         titleLabel.text =  @"恭喜您获得以下奖品";
    }else if(_sheetCellStyle == Prize_SkillDesc){
        [self createSkillDescView]; //技能描述
        titleLabel.text =  @"技能";
    }else if(_sheetCellStyle == Prize_PlayDesc){
        [self createPlayPrizeDescView]; //技能描述
        titleLabel.text =  @"玩法说明";
    }else if(_sheetCellStyle == Prize_Record){
        [self createPlayPrizeRecordView]; //技能记录描述
        titleLabel.text =  @"抽奖记录";
    }else if(_sheetCellStyle == Prize_RecordDetail){
        [self createPlayPrizeDetailRecordView]; //奖品记录详情
        titleLabel.text =  @"抽奖详情";
    }
    
}

-(void)createPlayPrizeDetailRecordView
{
    _prizeDetailRecordView = [[PrizeRecordDetailTableView alloc]init];
    [self.containerView addSubview:_prizeDetailRecordView];
    [_prizeDetailRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}


-(void)createPlayPrizeRecordView
{
    _prizeRecordView = [[PrizeRecordTableView alloc]init];
    [self.containerView addSubview:_prizeRecordView];
    [_prizeRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

-(void)createPlayPrizeDescView
{
    PrizePlayDescView *prizeDescView = [[PrizePlayDescView alloc]init];
    [self.containerView addSubview:prizeDescView];
    [prizeDescView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

-(void)createSkillDescView
{
    PrizeDescView *prizeDescView = [[PrizeDescView alloc]init];
    [self.containerView addSubview:prizeDescView];
    [prizeDescView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}


-(void)createRankingView
{
    _rankingView = [[PrizeRankTableView alloc]init];
    [self.containerView addSubview:_rankingView];
    [_rankingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

-(void)createPrizeGiftView
{
     _giftView = [[PrizeGiftTableView alloc]init];
    [self.containerView addSubview:_giftView];
    [_giftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

-(void)fetch_Prize_Gift:(NSArray *)datas
{
    _giftView.datas = datas;
}

-(void)fetch_Record_DefaultChooseSelect:(DrawPrizeType)drawType
{
    _prizeRecordView.drawType = drawType;
}

-(void)fetch_Record_Detail:(PrizeRecord *)record
{
    _prizeDetailRecordView.record = record;
}

//排行榜
-(void)fetch_Ranking_DrawType:(DrawPrizeType)drawType{
    _rankingView.drawType = drawType;
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
    
    if(self.actionDateDoneBlock){
        
        self.actionDateDoneBlock(nil);
    }
    
}

#pragma mark setter/getter

- (UIButton *)cancelBtn {
    
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setImage:[UIImage imageNamed:@"ic_nav_close_small"]
                    forState:UIControlStateNormal];
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
