//
//  PrizeRankTableView.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/8.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "PrizeRecordDetailTableView.h"
#import "GYRefreshTableView.h"
#import "PrizeRankCell.h"
#import "LMJEasyBlankPageView.h"
#import "SaleGrideView.h"
#import "RankingChildCell.h"
#import "PrizeTypeSelectView.h"
#import "PrizeRecordDetailListRequest.h"


@interface PrizeRecordDetailTableView()<UITableViewDelegate,UITableViewDataSource,DataRequestDelegate>

@property(nonatomic,strong) GYRefreshTableView *tableView;
@property(nonatomic,strong) NSMutableArray *datas;
@property(nonatomic,assign) NSInteger pageNumber;
@property(nonatomic,assign) NSInteger currentSelectDrawType;
@end


@implementation PrizeRecordDetailTableView

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
        make.top.mas_equalTo(29*2+10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    
//     __weak typeof(self) weakSelf =  self;
//    [_tableView initUpPullRefreshWithBlock:^{
//        //上拉加载
//        [weakSelf loadingMoreData];
//    }];
//
//    [_tableView initDownPullRefreshWithBlock:^{
//        //下拉刷新
//        [weakSelf refreshFirstPageData];
//    }];
    
}

//-(void)setDrawType:(DrawPrizeType)drawType
//{
//    _drawType = drawType;
////    [_selectView defaultChoosePrizeType:drawType];
//}

//刷新统计的view;
//-(void)refreshSumPrizeGridView
//{
//    [_sumPrizeGridView fitDataRefresh:@[@{}]];
//}


-(void)setRecord:(PrizeRecord *)record
{
    _record = record;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_W-30, 29)];
    SaleGrideView * sumPrizeGridView = [[SaleGrideView alloc]initColumnArr:@[@"转盘类型",@"抽奖方式",@"中奖总额",@"抽奖时间"] withDataArray:@[self.record] padding:15 interfaceType:4];
    [headerView addSubview:sumPrizeGridView];
    [sumPrizeGridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.equalTo(@(58));
    }];
    [self addSubview:headerView];
    
    //请求数据；
    [self refreshFirstPageData];
}



#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"RankingChildCell";
    RankingChildCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        CGFloat viewWidth =  (SCREEN_W-15*2);
        cell = [[RankingChildCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier withColumn:3 textItemWidth:viewWidth/3];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row%2==0){
        cell.contentView.backgroundColor = LJBackgroundColor;
    }else{
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#292929"];
    }
    
    PrizeRecord *record = [self.datas objectAtIndex:indexPath.row];
    cell.label0.text =  record.prizeName;
    cell.label1.text =  record.prizeMoney;
    cell.label2.text =  record.remark;
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
    UIView *sevenView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_W-30, 29)];
    sevenView.backgroundColor = [UIColor colorWithHexString:@"#292929"];
    NSArray *textArr = @[@"奖品",@"金额",@"备注"];
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

    return sevenView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
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
    PrizeRecordDetailListRequest *request = [[PrizeRecordDetailListRequest alloc]init];
    request.delegate = self;
    request.drawLogId = self.record.drawLogId; //记录id
    [[GYNetworkingManager shareInstance] executeRequest:request];
}

-(void)onRequestSuccess:(BaseResponse *)response
{
    if(response.requestAPICode == Http_Prize_RecordDetailList){
        
        NSArray *arr = response.responseObject;
        [self allLoadingCompleted:arr];
    }
}
@end


