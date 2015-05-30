//
//  UserInfoViewController.m
//  LiRickMicroBlog
//
//  Created by Rick on 4/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//

#import "UserInfoViewController.h"
#import "CommentViewController.h"
#import "LoginViewController.h"
#import "RepostViewController.h"
#import "WeiboSDK.h"
#import "WeiboCell.h"

#import "Define.h"

#import "AFNetworking.h"
#import "SVPullToRefresh.h"

#import "NetworkManager.h"


@interface UserInfoViewController ()<UIAlertViewDelegate,WBHttpRequestDelegate,NetWorkManagerDelegate,UITableViewDelegate,UITableViewDataSource,NetWorkManagerDelegate,WeiboCellDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *weiboDicArray;
@property (nonatomic,strong)NSMutableArray *weiboStatueArray;

@end

@implementation UserInfoViewController
- (id) init
{
    if(self = [super init])
    {
        self.user = [[UserModel alloc] init];
        self.weiboDicArray = [[NSMutableArray alloc] init];
        self.weiboStatueArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    
    self.view.backgroundColor =[UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, ([[UIScreen mainScreen] bounds].size.width),  ([[UIScreen mainScreen] bounds].size.height - 150)) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.userView = [[UserView alloc] init];
    self.userView.frame = CGRectMake(0, 64, ([[UIScreen mainScreen] bounds].size.width), 150);
    [self.view addSubview:self.userView];
    
    [self createNavi];
}

- (void) createNavi
{
    self.title = @"UserInfo";
    
    UIView *leftButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *leftButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftButtonImageView.image = [UIImage imageNamed:@"logout"];
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
    rightButtonImageView.image = [UIImage imageNamed:@"back->.png"];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:rightButtonImageView];
    [rightButtonView addSubview:rightButton];
    //创建home按钮
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak UserInfoViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    
    int64_t since_id = 0;
    NSDictionary *dic = @{@"since_id" : @(since_id)};
    [[NetworkManager sharedManager] getUserDelegate:self];
    [[NetworkManager sharedManager] getUserWeibo:(NSDictionary *)dic delegate:self];
}

- (void) insertRowAtTop
{
    __weak UserInfoViewController *weakSelf = self;
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        [weakSelf.tableView beginUpdates];
        int64_t since_id = 0;
        NSDictionary *dic = @{@"since_id" : @(since_id)};
        [[NetworkManager sharedManager] getUserWeibo:(NSDictionary *)dic delegate:self];
        [weakSelf.tableView endUpdates];
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    });
}

- (void) insertRowAtBottom
{
    __weak UserInfoViewController *weakSelf = self;
    
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
    {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
        cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    [cell bindWithWeibo:self.weiboStatueArray[indexPath.row] withDelegate:self];
    return cell;
    
}
#pragma mark 设置单元格高度，需自适应
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(self.weiboStatueArray.count)
    {
        WeiboModel *statue = [self.weiboStatueArray objectAtIndex:[indexPath row]];
        return [WeiboCell calculateWeiboCellheight:statue];
    }
    else
        return 90;
}
#pragma mark 选中单元格所产生事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *message = [[NSString alloc]initWithFormat:@"You selected%f\n%f",[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"赞", nil];
    
    [alert addButtonWithTitle:@"评论"];
    [alert addButtonWithTitle:@"转发"];
    
    [alert show];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.weiboStatueArray.count;
}


- (void)clickLeftButton
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout"
                                                    message:@"Do you want to quit?"
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:nil];

    [alert addButtonWithTitle:@"Yes"];
    [alert setTag:12];
    [alert show];
}
- (void)clickRightButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 0)
    {     // and they clicked OK.
        // do stuff
    }
    else if(buttonIndex == 1)
    {
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *accessTokenString = [userDefaultes stringForKey:@"access_token"];
        [WeiboSDK logOutWithToken:accessTokenString delegate:self withTag:@"user1"];
        [userDefaultes removeObjectForKey:@"access_token"];
        LoginViewController *rvc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:rvc animated:YES];
    }
}




#pragma mark 计算label高度
+ (CGFloat) calculateWidth:(NSString *) text
{
    CGFloat height;
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    NSDictionary *attributes = @{NSFontAttributeName:KTextFont};
    
    height = [text boundingRectWithSize:CGSizeMake(295, CGFLOAT_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:attributes
                                context:nil].size.height;
    
    return height ;
    
}

#pragma mark 代理返回：失败
- (void) receivedResponseFailed:(NSError *)error
{
    NSLog(@"%@",error);
}

#pragma mark 代理返回：成功
- (void) receivedResponseSuccess:(NSMutableDictionary *)dic type:(SendRequestType) type
{

    if(type == EReceiveUserWeibo)
    {
        NSArray *array = [dic objectForKey:@"statuses"];
        for(NSDictionary *dictionary in array)
        {
            
            WeiboModel *status = [[WeiboModel alloc] initWeiboWithData:dictionary];
            [self.weiboStatueArray addObject:status];
        }
        
        [self.tableView reloadData];
    }
    if (type == EReceiveUserInfo)
    {
        self.user = [dic objectForKey:@"user"];
        [self.userView bindWithUser:self.user];
        [self.view addSubview:self.userView];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
