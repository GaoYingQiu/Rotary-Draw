//
//  PrizeRankTableView.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/8.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "PrizeRecordTableView.h"
#import "GYRefreshTableView.h"
#import "PrizeRankCell.h"
#import "LMJEasyBlankPageView.h"
#import "SaleGrideView.h"
#import "RankingChildCell.h"
#import "PrizeTypeSelectView.h"
#import "PrizeRecordListRequest.h"
#import "GYPrizeContairView.h"


@interface PrizeRecordTableView()<UITableViewDelegate,UITableViewDataSource,DataRequestDelegate>

@property(nonatomic,strong) GYRefreshTableView *tableView;
@property(nonatomic,strong) NSMutableArray *datas;
@property(nonatomic,assign) NSInteger pageNumber;
//@property(nonatomic,strong) SaleGrideView *sumPrizeGridView;
//@property(nonatomic,strong) PrizeTypeSelectView *selectView;
@property(nonatomic,assign) NSInteger currentSelectDrawType;

@property(nonatomic,strong) NSMutableArray *personDataSource;
@property(nonatomic,strong) NSMutableArray *sectionTitleArray;

@end


@implementation PrizeRecordTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addPrizeTypeSelectView];
        [self addRefreshTableView];
    }
    return self;
}

-(NSMutableArray *)datas{
    if(!_datas){
        _datas = [[NSMutableArray alloc]init];
    }
    return _datas;
}

//-(void)addPrizeTypeSelectView
//{
//    _selectView = [[PrizeTypeSelectView alloc]initWithFrame:CGRectMake(15, 5, SCREEN_W-30, 36)];
//    MJWeakSelf
//    _selectView.selectBlock = ^(DrawPrizeType type) {
//        //根据选择的类型 请求数据；
//
//        weakSelf.currentSelectDrawType  = type;
//        //请求数据
//        [weakSelf refreshFirstPageData];
//    };
//    [self addSubview:_selectView];
//}

- (void)addRefreshTableView{
    
    UIView *sevenView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_W-30, 29)];
    sevenView.backgroundColor = [UIColor colorWithHexString:@"#292929"];
    NSArray *textArr = @[@"转盘类型",@"抽奖方式",@"中奖总额",@"抽奖时间"];
    CGFloat textItemWidth =  (SCREEN_W-30)/textArr.count;
    for(int i= 0; i< textArr.count; i++){
        
        UILabel * numtitleLabel = [[UILabel alloc]init];
        numtitleLabel.font =  LJFontMediumText(12);
        numtitleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        numtitleLabel.text = textArr[i];
        numtitleLabel.textAlignment = NSTextAlignmentCenter;
        [sevenView addSubview:numtitleLabel];
        
        [numtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(textItemWidth * i);
            make.top.bottom.mas_equalTo(0);
            make.width.equalTo(@(textItemWidth));
        }];
        
        UIView * _lineView4 = [[UIView alloc] init];
        _lineView4.backgroundColor = [UIColor colorWithWhite:1 alpha:0.05];
        [sevenView addSubview:_lineView4];
        [_lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(numtitleLabel);
            make.top.bottom.mas_equalTo(0);
            make.width.equalTo(@0.5);
        }];
    }
    
    UIView *_lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.05];
    [sevenView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.equalTo(@1);
    }];
    [self addSubview:sevenView];
    
    _sectionTitleArray = [[NSMutableArray alloc]init];
    _personDataSource = [[NSMutableArray alloc]init];
    
    _tableView                              = [[GYRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorInset               = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.estimatedRowHeight           = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollsToTop                 = YES;
    _tableView.separatorColor               = LJGray2Color;
    _tableView.tableFooterView              = [[UIView alloc] init];
    _tableView.delegate                     = self;
    _tableView.dataSource                   = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.rowHeight = 29;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = 0;
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(29); //46 selectView 的高度；
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
     __weak typeof(self) weakSelf =  self;
    [_tableView initUpPullRefreshWithBlock:^{
        //上拉加载
        [weakSelf loadingMoreData];
    }];
    
    [_tableView initDownPullRefreshWithBlock:^{
        //下拉刷新
        [weakSelf refreshFirstPageData];
    }];
    
    
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 29)]; //88+29
//    self.tableView.tableHeaderView = headerView;
//     _sumPrizeGridView = [[SaleGrideView alloc]initColumnArr:@[@"总投注金额",@"总中奖金额",@"总盈亏"] withDataArray:@[@{}] padding:15 interfaceType:4];
//    [headerView addSubview:_sumPrizeGridView];
//    [_sumPrizeGridView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(20);
//        make.right.mas_equalTo(0);
//        make.height.equalTo(@((1 + 1)*29));
//    }];
    
//
    self.pageNumber = 1;
    [self requestPrizeRecordList];
}

-(void)setDrawType:(DrawPrizeType)drawType
{
    _drawType = drawType;
//    [self refreshFirstPageData];
//    [_selectView defaultChoosePrizeType:drawType];
}

//刷新统计的view;
//-(void)refreshSumPrizeGridView
//{
//    [_sumPrizeGridView fitDataRefresh:@[@{}]];
//}


//分割；
- (NSMutableArray *)formatPersonalDataWithArray:(NSArray*)array isNewer:(BOOL)isNewer
{
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        NSString *timeString = @"";
        if ([obj isKindOfClass:[PrizeRecord class]]) {
            PrizeRecord *model = obj;
            if(model.drawTime.length >= 10){
                timeString = [model.drawTime substringToIndex:10];
            }
        }
        
        if ([self.sectionTitleArray containsObject:timeString]) {
            NSMutableArray *array = [self.personDataSource objectAtIndex:[self.sectionTitleArray indexOfObject:timeString]];
            if (isNewer) {
                [array insertObject:obj atIndex:idx];
            } else {
                [array addObject:obj];
            }
        } else {
            //将圈子加入该section对应的数据，
            NSMutableArray *circleArray = [NSMutableArray array];
            [circleArray addObject:obj];
            //加入标题
            if (isNewer) {
                [self.sectionTitleArray insertObject:timeString atIndex:0];
            } else {
                [self.sectionTitleArray addObject:timeString];
            }
            
            [self.personDataSource addObject:circleArray];
        }
    }];
    return self.personDataSource;
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_personDataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [_personDataSource objectAtIndex:section];
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"RankingChildCell";
    RankingChildCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        CGFloat viewWidth =  (SCREEN_W-15*2);
        cell = [[RankingChildCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier withColumn:4 textItemWidth:viewWidth/4];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row%2==0){
        cell.contentView.backgroundColor = LJBackgroundColor;
    }else{
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#292929"];
    }
    
   NSArray *arr = [_personDataSource objectAtIndex:indexPath.section];
    PrizeRecord *record = [arr objectAtIndex:indexPath.row];
    cell.label0.text =  record.drawName;
    cell.label1.text =  record.playType;
    
    if(record.bingo){
        cell.label2.text =  record.prizeMoney;
    }else{
        cell.label2.text =  @"未中奖";
    }
    
//    cell.label3.font = LJFontRegularText(10);
    if(record.drawTime.length > 10){
        cell.label3.text =  [record.drawTime substringFromIndex:10];
    }else{
        cell.label3.text = record.drawTime;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 29.000001f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 29)];
    v.backgroundColor = [UIColor colorWithHexString:@"#292929"];
    UILabel *titleLabel = [[UILabel alloc]init];
    NSString *str = [self.sectionTitleArray objectAtIndex:section];
    NSDate *date1 =  [NSDate dateByStr:str format:kSKDateFormatTypeYYYYMMDD];
    titleLabel.text = [NSDate stringFromDate:date1 format:kSKDateFormatTypeYYYYMMDD2];
    titleLabel.font = LJFontRegularText(12);
    titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.8];
    [v addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(v);
        make.left.mas_equalTo(15);
    }];
    return v;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [_personDataSource objectAtIndex:indexPath.section];
    PrizeRecord *record = [arr objectAtIndex:indexPath.row];
    if(record.bingo){
        GYPrizeContairView *sheetView = [[GYPrizeContairView alloc]initSheetStyle:Prize_RecordDetail  actionBlock:^(id selectedData) {
            
        }];
        [sheetView fetch_Record_Detail:record];
        [sheetView showInView];
    }
}


//所有数据加载完成，判断是否为空，显示空页面
- (void)allLoadingCompleted:(NSArray *)nextPageDataArr
{
    [_tableView headerEndRefresh];
    [_tableView footerEndRefresh];
    
    //以下判断是 针对下一页数据 判断处理
    if(self.pageNumber > 1){
        //下一页 没有数据
        if(nextPageDataArr.count == 0){
            [_tableView noticeNoMoreData];
        }
    }else{
        [self.datas removeAllObjects];
    }
    
    [_datas addObjectsFromArray:nextPageDataArr];
    
    BOOL has = _datas.count;
    
    //第一页 没有数据,隐藏footerView
    if(!has && self.pageNumber<=1){
        [_tableView hiddenRefreshFooter];
    }else{
        [_tableView showRefreshFooter];
    }
    [_tableView reloadData]; //刷新数据
    
    __weak typeof(self) weakSelf = self;
    [self.tableView configBlankPage:LMJEasyBlankPageViewTypeNoPrizeRecord hasData:has hasError:NO reloadButtonBlock:^(id sender) {
        [weakSelf.tableView headerBeginRefreshing];
    }];
}

-(void)refreshFirstPageData
{
    [_tableView resetNoMoreData]; //第一页 重置 footer状态
    [self.tableView showRefreshFooter];
    
    self.pageNumber = 1;
    [self requestPrizeRecordList];
}

-(void)loadingMoreData
{
    self.pageNumber ++;
    [self requestPrizeRecordList];
}

-(void)requestPrizeRecordList
{
    PrizeRecordListRequest *request = [[PrizeRecordListRequest alloc]init];
    request.delegate = self;
    request.pageNum = self.pageNumber;
    request.pageSize = 20;
    [[GYNetworkingManager shareInstance] executeRequest:request];
}

-(void)onRequestSuccess:(BaseResponse *)response
{
    if(response.requestAPICode == Http_Prize_RecordList){
        
        if(self.pageNumber == 1){
            [self.personDataSource removeAllObjects];
            [self.sectionTitleArray removeAllObjects];
        }
        NSArray *arr = response.responseObject;
        [self allLoadingCompleted:arr];
        [self formatPersonalDataWithArray:arr isNewer:NO];
        [self.tableView reloadData];
    }
}
@end


