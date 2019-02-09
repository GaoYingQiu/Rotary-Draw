//
//  PrizeRankTableView.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/8.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "PrizeDescView.h"
#import "GYRefreshTableView.h"
#import "PrizeGiftCell.h"
#import "DescBankPlaceCell.h"
#import "PrizePropsRequest.h"

@interface PrizeDescView()<UITableViewDelegate,UITableViewDataSource,DataRequestDelegate>

@property(nonatomic,strong) GYRefreshTableView *tableView;
@property(nonatomic,assign) NSInteger pageNumber;
@property(nonatomic,strong) HXQActivityPrizeModel *prizeProps;
@end


@implementation PrizeDescView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addRefreshTableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
        [self requestPrizeProps];
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

-(void)requestPrizeProps
{
    PrizePropsRequest *request = [[PrizePropsRequest alloc]init];
    request.delegate = self;
    [[GYNetworkingManager shareInstance] executeRequest:request];
}

-(void)onRequestSuccess:(BaseResponse *)response
{
    if(response.requestAPICode == Http_Prize_Props){
        self.prizeProps = response.responseObject;
        [self.tableView reloadData];
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row== 0){
        return 70;
    }else{
        return UITableViewAutomaticDimension;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        PrizeGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrizeGiftCell"];
        if(cell == nil){
            cell=[[[NSBundle mainBundle]loadNibNamed:@"PrizeGiftCell" owner:nil options:nil]
                      firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:self.prizeProps.prizeIcon] placeholderImage:[UIImage imageNamed:@"ic_ingots"]];
        if(self.prizeProps.count){
            cell.numLabel.text = [NSString stringWithFormat:@"x%ld",self.prizeProps.count];
            cell.noGetPrizeLabel.text = [NSString stringWithFormat:@"剩余次数:%ld",self.prizeProps.rtimes];
            cell.noGetPrizeLabel.textColor = [UIColor colorWithHexString:@"#FFA532"];
        }else{
            cell.numLabel.text = @"";
            cell.noGetPrizeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.3];
        }
        cell.rankLabel.text = self.prizeProps.prizeName;
        if(!cell.rankLabel.text){
            cell.rankLabel.text = @"财源滚滚";
        }
        cell.timesLabel.text = @"转盘抽取到奖金200元时奖金翻10倍";
        return cell;
    }else{
        static NSString *identifier = @"DescBankPlaceCell";
        DescBankPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            cell= [[DescBankPlaceCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.lineSpacing = 5;
        
        NSString *title =@"技能说明";
        NSString *conent = @"财源滚滚：通过转盘获得技能后即刻生效于接下来的10次黄金转盘游戏中，在技能生效期间，抽得指定奖项 200元时，获得奖金数量X10倍；\n 例：通过元宝财源滚滚技能抽取到奖金200元时，总计可获得2000元奖金。";
        
        NSAttributedString *atributeStr = [[NSAttributedString alloc] initWithString:conent attributes:@{NSFontAttributeName:LJFontRegularText(14) ,NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.6],NSParagraphStyleAttributeName : paragraphStyle}];
        cell.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
        cell.titleLabel.font = LJFontRegularText(16);
        cell.titleLabel.text = title;
        cell.contentLabel.attributedText = atributeStr;
        
        return cell;
    }
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


