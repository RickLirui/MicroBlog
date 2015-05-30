//
//  MainViewController.m
//  LiRickMicroBlog
//
//  Created by Rick on 4/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//
#import "AppDelegate.h"

#import "MainViewController.h"
#import "UserInfoViewController.h"
#import "RepostViewController.h"
#import "SendViewController.h"
#import "CommentViewController.h"
#import "WBHttpRequest.h"


#import "WeiboModel.h"
#import "WeiboCell.h"

#import "WBHttpRequest.h"


#import "AFNetworking.h"
#import "SVPullToRefresh.h"

#import "Define.h"

#import "NetworkManager.h"


@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate,NetWorkManagerDelegate,WeiboCellDelegate>

//@property (nonatomic, strong) NSArray *statusFrames;
@property (nonatomic, retain) UIButton *shareButton;

@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) efreshControl *refreshControl;
@property (nonatomic,strong)NSMutableArray *weiboDicArray;
@property (nonatomic,strong)NSMutableArray *weiboStatueArray;


@end


@implementation MainViewController


#pragma mark 初始化函数
- (id) init
{
    if(self = [super init])
    {
        self.weiboDicArray = [[NSMutableArray alloc] init];
        self.weiboStatueArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark load函数
- (void)loadView
{
    [super loadView];
    self.title = @"Weibo";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self createNavi];

}

#pragma mark 设置导航栏
- (void)createNavi
{
    
    //创建homeButtonView层
    UIView *leftButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *leftButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftButtonImageView.image = [UIImage imageNamed:@"userinfo.png"];
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [leftButtonView addSubview:leftButtonImageView];
    [leftButtonView addSubview:leftButton];
    //创建home按钮
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButtonView];
    self.navigationItem.leftBarButtonItem=leftButtonItem;
    
    UIView *rightButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *rightButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightButtonImageView.image = [UIImage imageNamed:@"new.png"];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:rightButtonImageView];
    [rightButtonView addSubview:rightButton];
    //创建home按钮
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}

#pragma mark 加载数据
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak MainViewController *controller = self;
    self.tableView.pullToRefreshView.frame = CGRectMake(0, 64, 0, 0);
    [self.tableView addPullToRefreshWithActionHandler:^{
         [controller insertRowAtTop];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [controller insertRowAtBottom];
    }];

    int64_t since_id = 0;
    NSDictionary *dic = @{@"since_id" : @(since_id)};
    [[NetworkManager sharedManager] getWeibo:dic delegate:self];
}

- (void)insertRowAtTop
{
    __weak MainViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [weakSelf.tableView beginUpdates];
    int64_t since_id = 0;
    NSDictionary *dic = @{@"since_id" : @(since_id)};
    [[NetworkManager sharedManager] getWeibo:dic delegate:weakSelf];
    [weakSelf.tableView endUpdates];
    [weakSelf.tableView.pullToRefreshView stopAnimating];
    });
}

- (void)insertRowAtBottom
{
    __weak MainViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [weakSelf.tableView beginUpdates];
    int64_t max_id = [self.weiboStatueArray[self.weiboStatueArray.count - 1] weiboID];
    NSDictionary *dic = @{@"max_id" : @(max_id)};

        [[NetworkManager sharedManager] getWeibo:dic delegate:weakSelf];
        [weakSelf.tableView endUpdates];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}

#pragma mark 初始化Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
        cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    [cell bindWithWeibo:self.weiboStatueArray[indexPath.row] withDelegate:self];
    return cell;
    
}

#pragma mark 代理方法：设置单元格组数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.weiboStatueArray.count;
}

#pragma mark 设置单元格高度，需自适应
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(self.weiboStatueArray.count)
    {
        WeiboModel *statue = [self.weiboStatueArray objectAtIndex:[indexPath row]];
        return [WeiboCell calculateWeiboCellheight:statue] + 2;
    }
    else
        return 90;
}

#pragma mark 选中单元格所产生事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboModel *statue = [self.weiboStatueArray objectAtIndex:[indexPath row]];
    CommentViewController *cmv = [[CommentViewController alloc] initWithWeiboCell:statue];
    [self.navigationController pushViewController:cmv animated:YES];
}

#pragma mark 点击按键：用户信息
- (void)clickLeftButton
{
    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}


#pragma mark 点击按键：发送微博
- (void)clickRightButton
{
    SendViewController *sendVC = [[SendViewController alloc] init];
    [self.navigationController pushViewController:sendVC animated:YES];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 代理返回：失败
- (void) receivedResponseFailed:(NSError *)error
{
    NSLog(@"%@",error);
}

#pragma mark 代理返回：成功
- (void) receivedResponseSuccess:(NSMutableDictionary *)dic type:(SendRequestType) type
{
    if(type == EReceiveHomeWeibo)
    {
        if ([self.weiboStatueArray count] != 0)
            [self.weiboStatueArray removeAllObjects];
        NSArray *array = [dic objectForKey:@"statuses"];
        for(NSDictionary *dictionary in array)
        {
            WeiboModel *status = [[WeiboModel alloc] initWeiboWithData:dictionary];
            [self.weiboStatueArray addObject:status];
        }
        [self.tableView reloadData];
    }
    else if(type == EReceiveHomeWeiboRefresh)
    {
        NSArray *array = [dic objectForKey:@"statuses"];
        for(NSDictionary *dictionary in array)
        {
            WeiboModel *status = [[WeiboModel alloc] initWeiboWithData:dictionary];
            [self.weiboStatueArray addObject:status];
        }
        [self.tableView reloadData];

    }
}

#pragma mark 代理方法：点击评论按键
- (void) commentPressed:(WeiboModel *)weibo
{
    CommentViewController *cmv = [[CommentViewController alloc] initWithWeiboCell:weibo];
    [self.navigationController pushViewController:cmv animated:YES];
}
#pragma mark 代理方法：点击赞按键
- (void) likePressed:(WeiboModel *)weibo
{
    NSLog(@"哈哈，没用。");
}
#pragma mark 代理方法：点击转发按键
- (void) repostPressed:(WeiboModel *)weibo
{
    RepostViewController *modalView = [[RepostViewController alloc] initWithWeiboModel:weibo];
    modalView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:modalView];
    
    [self presentViewController:nav animated:YES completion:nil];

}

@end
