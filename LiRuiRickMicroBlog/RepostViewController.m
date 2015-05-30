//
//  RepostViewController.m
//  LiRickMicroBlog
//
//  Created by Rui.L on 5/21/15.
//  Copyright (c) 2015 LiRick. All rights reserved.
//

#import "RepostViewController.h"
#import "WeiboCell.h"
#import "NetworkManager.h"
@interface RepostViewController ()<NetWorkManagerDelegate,UITextViewDelegate>

@property (nonatomic,strong)NSString *text;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UILabel *weiboText;
@property (nonatomic,strong)WeiboModel *weibo;


@end

@implementation RepostViewController

- (id) initWithWeiboModel:(WeiboModel *) weibo
{
    if(self = [super init])
    {
        self.text = [[NSString alloc] init];
        self.weiboText = [[UILabel alloc] init];
        self.weiboText.lineBreakMode = NSLineBreakByWordWrapping;
        self.weiboText.numberOfLines = 0;
        self.weibo = weibo;
    }
    return self;
}
- (void) loadView
{
    [super loadView];
    [self creatNavi];
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    self.textView = [[UITextView alloc] init];
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;//边框颜色
    self.textView.backgroundColor= [UIColor cyanColor];//背景颜色
    [self.textView.layer setCornerRadius:10];//圆角
    self.textView.layer.borderWidth = 1.f;//边框宽度
    self.textView.font = [UIFont fontWithName:@"Arial"size:18.0];//框内字体与颜色
    [self.textView becomeFirstResponder];//是其为第一目标
    self.textView.returnKeyType = UIReturnKeyGoogle;//设置键盘return键的默认值
    self.textView.keyboardType = UIKeyboardTypeDefault;//设置默认键盘
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//
    
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.textView.frame = CGRectMake(10, 10, 355, 200);
    [self.view addSubview:self.textView];



}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatWeiboLabel];

}

- (void) creatWeiboLabel
{
    NSString *name = self.weibo.name;
    NSString *test = [name stringByAppendingString:@":"];
    NSString *WeiboText = self.weibo.text;
    NSString *connect = [test stringByAppendingString:WeiboText];
    self.weiboText.text = connect;

    CGFloat contentHeight = [WeiboCell calculateTextHeight:connect];
    self.weiboText.frame = CGRectMake(10, 215, [[UIScreen mainScreen] bounds].size.width- 20, contentHeight);
    self.weiboText.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.weiboText];
}

- (void) creatNavi
{
    self.title = @"Repost Weibo";

    UIView *leftButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *leftButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftButtonImageView.image = [UIImage imageNamed:@"back.png"];
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
    rightButtonImageView.image = [UIImage imageNamed:@"send.png"];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:rightButtonImageView];
    [rightButtonView addSubview:rightButton];
    //创建home按钮
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}



- (void) clickLeftButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) clickRightButton
{
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSDictionary *dic = @{@"id":@(self.weibo.weiboID),
                          @"access_token":access_token,
                          @"status":self.textView.text};
    [[NetworkManager sharedManager] postRepostWeibo:dic delegate:self];

}
#pragma mark 代理返回：失败
- (void) receivedResponseFailed:(NSError *)error
{
    NSLog(@"%@",error);
}

#pragma mark 代理返回：成功
- (void) receivedResponseSuccess:(NSMutableDictionary *)dic type:(SendRequestType) type
{
    if(type == ESendRequestTypeRepost)
    {
        self.textView.text = @"";
        NSString *message = [[NSString alloc]initWithFormat:@"Repost Success!"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
