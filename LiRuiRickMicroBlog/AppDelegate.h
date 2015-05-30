//
//  AppDelegate.h
//  LiRuiRickMicroBlog
//
//  Created by Rick on 4/5/15.
//  Copyright (c) 2015年 LiRuiRick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"




@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString* wbtoken;
    NSString* wbCurrentUserID;
}

@property (strong, nonatomic) UIWindow *window;


@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;



@property (strong, nonatomic) UINavigationController *navController;



@end

