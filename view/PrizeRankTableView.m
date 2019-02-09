//
//  PrizeRankTableView.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/8.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "PrizeRankTableView.h"
#import "GYRefreshTableView.h"
#import "PrizeRankCell.h"
#import "LMJEasyBlankPageView.h"
#import "PrizeRankingListRequest.h"
#import "MBProgressHUD+YF.h"


@interface PrizeRankTableView()<UITableViewDelegate,UITableViewDataSource,DataRequestDelegate>

@property(nonatomic,strong) GYRefreshTableView *tableView;
@property(nonatomic,strong) NSMutableArray *datas;
@property(nonatomic,assign) NSInteger pageNumber;
@end


@implementation PrizeRankTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addRefreshTableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
    }
    return self;
}

-(NSMutableArray *)datas{
    if(!_datas){
        _datas = [[NSMutableArray alloc]init];
    }
    return _datas;
}


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
    _tableView.rowHeight = 54;
    _tableView.separatorStyle = 0;
    [self addSubview:_tableView];
    
    //默认 可刷新，可加载更多；
//    self.canRefresh = YES;
//    self.canLoadMore = YES;
}

-(void)setBNeedHeaderViewFlag:(BOOL)bNeedHeaderViewFlag
{
    _bNeedHeaderViewFlag = bNeedHeaderViewFlag;
    if(_bNeedHeaderViewFlag){
        [self configMoreTitleView];
    }
}

//-(void)setCanRefresh:(BOOL)canRefresh
//{
//    _canRefresh = canRefresh;
//    if(_canRefresh){
//        __weak typeof(self) weakSelf =  self;
//        [_tableView initDownPullRefreshWithBlock:^{
//            //下拉刷新
//            [weakSelf refreshFirstPageData];
//        }];
//    }else{
//        _tableView.mj_header = nil;
        
//        [self refreshFirstPageData]; //直接加载第一页数据；
//    }
//}


//配置点击更多view
-(void)configMoreTitleView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 44)];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = LJFontRegularText(16);
    titleLabel.text = @"奖金排行榜";
    titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.8];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setTitle:@"查看全部" forState:0];
    [moreBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:0];
    moreBtn.titleLabel.font = LJFontRegularText(12);
    [headerView addSubview:moreBtn];
    [moreBtn addTarget:self action:@selector(goMoreRankingAction) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(0);
        make.width.equalTo(@55);
    }];
    self.tableView.tableHeaderView = headerView;
}


-(void)goMoreRankingAction
{
    if(_delegate && [_delegate respondsToSelector:@selector(goLookMoreRankingPage)]){
        [_delegate goLookMoreRankingPage];
    }
}

//-(void)setCanLoadMore:(BOOL)canLoadMore
//{
//    _canLoadMore = canLoadMore;
//    if(_canLoadMore){
//        MJWeakSelf
//        [_tableView initUpPullRefreshWithBlock:^{
//            //上拉加载
//            [weakSelf loadingMoreData];
//        }];
//
//    }else{
//        _tableView.mj_footer = nil;
//    }
//}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.bNeedHeaderViewFlag){
        return self.datas.count<3?self.datas.count:3;  //抽奖页面显示的3个排名；
    }
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrizeRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrizeRankCell"];
    if(cell == nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"PrizeRankCell" owner:nil options:nil]
                  firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.icon.hidden = NO;
    cell.numLabel.hidden = YES;
    if(indexPath.row == 0){
        cell.icon.image = [UIImage imageNamed:@"ic_badge_1"];
    }else  if(indexPath.row == 1){
        cell.icon.image = [UIImage imageNamed:@"ic_badge_2"];
    }else if(indexPath.row == 2){
        cell.icon.image = [UIImage imageNamed:@"ic_badge_3"];
    }
    
    cell.icon.hidden = indexPath.row >=3;
    cell.numLabel.hidden = indexPath.row <3;
    if(self.datas.count){
        RankingUserModel *model = [self.datas objectAtIndex:indexPath.row];
        cell.numLabel.text =  [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.moneyLabel.text = [NSString stringWithFormat:@"￥%@",model.totalMoney];
        cell.timesLabel.text = [NSString stringWithFormat:@"中奖次数：%ld次",model.drawCount];
        cell.rankLabel.text = model.userName;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}



//所有数据加载完成，判断是否为空，显示空页面
//- (void)allLoadingCompleted:(NSArray *)nextPageDataArr
//{
//    [_tableView headerEndRefresh];
//    [_tableView footerEndRefresh];
//
//    //以下判断是 针对下一页数据 判断处理
//    if(self.pageNumber > 1){
//        //下一页 没有数据
//        if(nextPageDataArr.count == 0){
//            [_tableView noticeNoMoreData];
//        }
//    }else{
//        [self.datas removeAllObjects];
//    }
//
//    [_datas addObjectsFromArray:nextPageDataArr];
//
//    BOOL has = _datas.count;
//
//    //第一页 没有数据,隐藏footerView
//    if(!has && self.pageNumber<=1){
//        [_tableView hiddenRefreshFooter];
//    }else{
//        [_tableView showRefreshFooter];
//    }
//    [_tableView reloadData]; //刷新数据
//
//    __weak typeof(self) weakSelf = self;
//    [self.tableView configBlankPage:LMJEasyBlankPageViewTypeNoData hasData:has hasError:NO reloadButtonBlock:^(id sender) {
//        [weakSelf.tableView headerBeginRefreshing];
//    }];
//}

//-(void)refreshFirstPageData
//{
//    [_tableView resetNoMoreData]; //第一页 重置 footer状态
//    [self.tableView showRefreshFooter];
//
//    [self requestPrizeRanking];
//}

-(void)requestPrizeRanking{
    [MBProgressHUD showLoading:@"加载中"];
    PrizeRankingListRequest *request = [[PrizeRankingListRequest alloc]init];
    request.delegate = self;
    request.drawPrizeType = self.drawType;
    [[GYNetworkingManager shareInstance] executeRequest:request];
}

-(void)onRequestSuccess:(BaseResponse *)response
{
    [MBProgressHUD hideHUDForView:nil];
    if(response.requestAPICode == Http_Prize_Ranking){
        [self.datas removeAllObjects];
        [self.datas addObjectsFromArray:response.responseObject];
        [self.tableView reloadData];
    }
}

-(void)setDrawType:(DrawPrizeType)drawType
{
    _drawType = drawType;
    [self requestPrizeRanking];
}

//-(void)loadingMoreData
//{
//
//}
@end


