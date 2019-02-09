//
//  PrizeRankTableView.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/8.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "PrizeGiftTableView.h"
#import "GYRefreshTableView.h"
#import "PrizeGiftCell.h"
#import "HXQActivityPrizeModel.h"


@interface PrizeGiftTableView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) GYRefreshTableView *tableView;
@property(nonatomic,assign) NSInteger pageNumber;
@end


@implementation PrizeGiftTableView

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
    _tableView.rowHeight = 70;
    _tableView.separatorStyle = 0;
    [self addSubview:_tableView];
    
}

-(void)setDatas:(NSArray *)datas
{
    _datas = datas;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrizeGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrizeGiftCell"];
    if(cell == nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"PrizeGiftCell" owner:nil options:nil]
                  firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.noGetPrizeLabel.hidden = YES;
    }
    
    HXQActivityPrizeModel *model = [self.datas objectAtIndex:indexPath.row];
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:model.prizeIcon] placeholderImage:nil];
    cell.numLabel.text = [NSString stringWithFormat:@"x%ld",model.count];
    cell.rankLabel.text = model.prizeName;
    cell.timesLabel.text = model.desc;
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


@end


