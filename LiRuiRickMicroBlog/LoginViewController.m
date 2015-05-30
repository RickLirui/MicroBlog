//
//  LoadViewController.m
//  LiRickMicroBlog
//
//  Created by Rick on 4/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

#import "Define.h"

@interface LoginViewController ()<UIScrollViewDelegate>
@property (nonatomic, retain) UILabel *welcomeLabel;
@property (nonatomic, retain) UILabel *loginTextLabel;



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Login Window";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.hidesBackButton = YES;//返回按键消失
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
      [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
    self.welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 320, 100)];
    self.welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel.numberOfLines = 9;
    [scrollView addSubview:self.welcomeLabel];
    self.welcomeLabel.text = NSLocalizedString(@"请登录新浪微博", nil);
    
    
    UIButton *ssoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ssoButton setTitle:NSLocalizedString(@"进行微博认证", nil) forState:UIControlStateNormal];
    [ssoButton addTarget:self action:@selector(ssoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    ssoButton.frame = CGRectMake(30, 250, 320, 100);
    [scrollView addSubview:ssoButton];
    
}
//
- (void)ssoButtonPressed
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI =KRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSOAccess": @"ViewController"};
    [WeiboSDK sendRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
