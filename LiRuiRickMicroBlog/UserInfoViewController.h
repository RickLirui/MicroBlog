//
//  UserInfoViewController.h
//  LiRickMicroBlog
//
//  Created by Rick on 4/5/15.
//  Copyright (c) 2015年 LiRick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UserView.h"
#import "UserModel.h"

@interface UserInfoViewController : UIViewController


@property(nonatomic,strong)UserView *userView;
@property(nonatomic,strong)UserModel *user;

+ (CGFloat) calculateWidth:(NSString *) text;
@end
