//
//  PrizeRankTableView.m
//  Ying2018
//
//  Created by qiugaoying on 2019/1/8.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import "PrizePlayDescView.h"
#import "GYRefreshTableView.h"
#import "DescBankPlaceCell.h"

@interface PrizePlayDescView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) GYRefreshTableView *tableView;
@property(nonatomic,assign) NSInteger pageNumber;
@end


@implementation PrizePlayDescView

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


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"DescBankPlaceCell";
    DescBankPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell= [[DescBankPlaceCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    cell.titleLabel.font = LJFontRegularText(16);
    cell.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
    }];
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 5;
    
    NSString *title =@"【欢乐转盘玩法规则】";
    NSString *conent = @"单抽:\n用户单击“点击开始”按钮，系统自动扣除玩家1元钱，玩家获得一次转动轮盘的机会。扣除玩家金钱的同时自动转动轮盘；\n\n十连抽:\n用户选中“十连抽”按钮，再次单击“点击开始”按钮，系统自动扣除玩家10元钱，玩家获得十次转动轮盘的机会，扣除玩家金钱的同时自动转动轮盘；\n\n三十连抽：\n用户选中“三十连抽”按钮，再次单击“点击开始”按钮，系统自动扣除玩家30元钱，玩家获得十次转动轮盘的机会，扣除玩家金钱的同时自动转动轮盘；\n\n【黄金转盘玩法规则】\n单抽:\n用户单击“点击开始”按钮，系统自动扣除玩家100元钱，玩家获得一次转动轮盘的机会。扣除玩家金钱的同时自动转动轮盘；\n\n十连抽:\n用户选中“十连抽”按钮，再次单击“点击开始”按钮，系统自动扣除玩家1000元钱，玩家获得十次转动轮盘的机会，扣除玩家金钱的同时自动转动轮盘；\n\n三十连抽：\n用户选中“三十连抽”按钮，再次单击“点击开始”按钮，系统自动扣除玩家3000元钱，玩家获得十次转动轮盘的机会，扣除玩家金钱的同时自动转动轮盘；\n\n【暴走规则】\n当欢乐转盘/黄金转盘的暴走值累计到达400，开启欢乐转盘/黄金转盘暴走时间并且持续3分钟，暴走期间所有奖励中奖概率统一翻3倍，有机会获得4800元大奖哦！！！\n\n【宝箱规则】\n玩家每转动一次黄金转盘，将获得一个星星。累计星星可以打开宝箱进行夺宝，每种奖励只能兑换一次。按照顺序兑换由小到大，完成上一阶段兑换才能兑换下一阶段奖励，多玩多的哦~星星累计时间为每个自然周的周一至周日。每个累计周期的最后一日晚23:59:59,累计的所有星星将失效。\n\n【技能规则】\n玩家通过黄金转盘游戏，可以获得财源滚滚技能，获取技能后即可生效于接下来的10次黄金转盘游戏中；\n技能效果：在技能生效的游戏中，若玩家获取到技能指定金额时，总共可获得技能指定倍数的该金额奖励";
    
   
    NSAttributedString *atributeStr = [[NSAttributedString alloc] initWithString:conent attributes:@{NSFontAttributeName:LJFontRegularText(14) ,NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.6],NSParagraphStyleAttributeName : paragraphStyle}];
    
    cell.titleLabel.text = title;
    cell.contentLabel.attributedText = atributeStr;
    
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


