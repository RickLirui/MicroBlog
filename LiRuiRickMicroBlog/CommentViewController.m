//
//  CommentViewController.m
//  LiRickMicroBlog
//
//  Created by Rui.L on 5/22/15.
//  Copyright (c) 2015 LiRick. All rights reserved.
//

#import "CommentViewController.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "WeiboCell.h"
#import "CommentCell.h"
#import "NetworkManager.h"
#import "UIImageView+WebCache.h"
#import "SVPullToRefresh.h"

@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource,NetWorkManagerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) WeiboModel *weibo;
@property (nonatomic,strong) WeiboView *weiboView;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UITextField *text;
@property (nonatomic,strong)NSMutableArray *weiboCommentArray;


@end

@implementation CommentViewController

- (id)initWithWeiboCell:(WeiboModel *) weibo
{
    if(self = [super init])
    {
        self.weibo = weibo;
        self.tableView = [[UITableView alloc] init];
        self.weiboCommentArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.view.backgroundColor =[UIColor whiteColor];
    [self creatTextField];
    [self creatTableView];
    [self addWeiboView];


}

- (void) viewDidLoad
{
    [super viewDidLoad];
    __weak CommentViewController *weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    
    NSDictionary *dic = @{@"id":@(self.weibo.weiboID)};
    [[NetworkManager sharedManager] getWeiboComment:(NSDictionary *)dic delegate:self];
}

- (void) creatTextField
{
    self.text.delegate = self;
    self.text = [[UITextField alloc] initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height - 40- 64), ([[UIScreen mainScreen] bounds].size.width), 40)];
    self.text.delegate = self;
    [self.text setBorderStyle:UITextBorderStyleRoundedRect];
    self.text.autocorrectionType = UITextAutocorrectionTypeNo;
    self.text.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.text.returnKeyType = UIReturnKeyDone;
    self.text.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.text.backgroundColor = [UIColor cyanColor];
    self.text.keyboardType = UIKeyboardTypeDefault;
    self.text.returnKeyType =UIReturnKeyDone;
    [self.view addSubview:self.text];
}
- (void) creatTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ([[UIScreen mainScreen] bounds].size.width),  [[UIScreen mainScreen] bounds].size.height - 64 - 40)  style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void) addWeiboView
{
    self.weiboView = [[WeiboView alloc] initWithWeibo:self.weibo];
    self.weiboView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.weiboView.height);
    self.tableView.tableHeaderView = self.weiboView;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.text resignFirstResponder];
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSDictionary *dic = @{@"id":@(self.weibo.weiboID),
                          @"access_token":access_token,
                          @"comment":self.text.text};
    [[NetworkManager sharedManager] postWeiboComment:dic delegate:self];
    
    
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y +=246;
    frame.size. height -=246;
    self.view.frame = frame;
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{ //当点触textField内部，开始编辑都会调用这个方法。textField将成为first responder
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -=246;
    frame.size.height +=246;
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}





- (void) insertRowAtTop
{
    __weak CommentViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        
        NSDictionary *dic = @{@"id":@(self.weibo.weiboID)};
        [[NetworkManager sharedManager] getWeiboComment:(NSDictionary *)dic delegate:self];
        
        [weakSelf.tableView endUpdates];
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    });
}


- (void) insertRowAtBottom
{
    __weak CommentViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        NSDictionary *d =self.weiboCommentArray[self.weiboCommentArray.count - 1];
        NSString *flag = d[@"id"];
        int64_t max_id = [flag longLongValue];
        NSDictionary *dic = @{@"max_id" : @(max_id),
                              @"id":@(self.weibo.weiboID)};
        [[NetworkManager sharedManager] getWeiboComment:(NSDictionary *)dic delegate:self];
        [weakSelf.tableView endUpdates];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}






#pragma mark 初始化Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
   
    NSDictionary *dic =  self.weiboCommentArray[indexPath.row];
    [cell bindWithComment:dic];
    return cell;
            
}

#pragma mark 代理方法：设置单元格组数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.weiboCommentArray.count;
}

#pragma mark 设置单元格高度，需自适应
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 40;
}

#pragma mark 选中单元格所产生事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark 代理返回：失败
- (void) receivedResponseFailed:(NSError *)error
{
    NSLog(@"%@",error);
}

#pragma mark 代理返回：成功
- (void) receivedResponseSuccess:(NSMutableDictionary *)dic type:(SendRequestType) type
{
    if(type == EReceiveHomeWeiboComment)
    {
        NSArray *array = [dic objectForKey:@"comments"];
        for(NSDictionary *dictionary in array)
            [self.weiboCommentArray addObject:dictionary];
        [self.tableView reloadData];

    }
    if(type == ESendRequestTypeComment)
    {
        self.text.text = @"";
        NSString *message = [[NSString alloc]initWithFormat:@"Comment Success!"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:nil];
        [alert show];
    }
    if(type == EReceiveHomeWeiboCommentRefresh)
    {
        NSArray *array = [dic objectForKey:@"comments"];
        for(NSDictionary *dictionary in array)
            [self.weiboCommentArray addObject:dictionary];
        [self.tableView reloadData];

    }
}
@end
