//
//  AppDelegate.m
//  LiRickMicroBlog
//
//  Created by Rick on 4/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "Define.h"

@interface AppDelegate ()<WeiboSDKDelegate,WBHttpRequestDelegate>

@end

@implementation AppDelegate

@synthesize wbtoken;
@synthesize wbCurrentUserID;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:KAppKey];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:[UIColor cyanColor]];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *accessTokenString = [userDefaultes stringForKey:@"access_token"];
    if(accessTokenString)
    {
        MainViewController *vc = [[MainViewController alloc] init];
        self.navController = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    else
    {
        LoginViewController *vc = [[LoginViewController alloc] init];
        self.navController = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *userAccessToken = [(WBAuthorizeResponse *)response accessToken];
        NSString *userId = [(WBAuthorizeResponse *)response userID];
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithCapacity:2];
        [param setObject:userAccessToken forKey:@"access_token"];
        [param setObject:userId forKey:@"uid"];
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        
        [WBHttpRequest requestWithAccessToken:userAccessToken url:KRedirectURI httpMethod:@"GET" params:param delegate:self withTag:@"userInfo"];
        
        MainViewController *vc = [[MainViewController alloc] init];
        [self.navController pushViewController:vc animated:YES];
        
        NSUserDefaults *userDefaultsSave = [NSUserDefaults standardUserDefaults];
        [userDefaultsSave setObject:userAccessToken forKey:@"access_token"];
        [userDefaultsSave setObject:userId forKey:@"uid"];
        
        
        [userDefaultsSave synchronize];
    }
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self ];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}




@end
